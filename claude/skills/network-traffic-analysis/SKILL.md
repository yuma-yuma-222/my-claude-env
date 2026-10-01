---
name: network-traffic-analysis
description: >-
  An executable workflow for analyzing network traffic data for defensive
  security research — pcap captures, NetFlow/IPFIX records, Zeek logs, and
  darknet (network telescope) sensor data. Governs capture-context checks
  (sampling, truncation, clock issues), triage and inventory, reproducible
  tshark/Zeek/scapy reduction pipelines, darknet-specific interpretation
  (backscatter vs. scanning vs. misconfiguration, spoofing, sensor bias),
  DDoS and scan characterization, ground-truth labeling honesty, and
  privacy-conscious data handling. Load this skill whenever the task
  touches traffic data — 「pcapを解析して」「ダークネットのデータ」
  「トラフィックを見て」「パケットキャプチャ」「DDoSの特徴を出して」,
  Wireshark/tshark work, flow analysis, scan or backscatter analysis —
  even if the user only asks for a quick look at a capture file.
  Statistical rigor for the conclusions belongs to
  data-analysis-methodology; this skill owns the traffic-domain semantics.
---

# Network Traffic Analysis

## Purpose

Traffic analysis fails quietly: conclusions drawn from a capture that dropped half its packets, "attacks" that are checksum-offload artifacts, darknet scans attributed to hosts that never sent them (spoofing), diurnal patterns read as anomalies, and pipelines that nobody — including their author — can rerun. The domain knowledge that prevents these failures is what this skill encodes. The output standard: every claim about the traffic is traceable to a reproducible extraction from named raw data, with the capture's own limitations stated alongside.

## Division of labor

This skill owns traffic semantics: what the packets/flows mean and how to reduce them faithfully. Once the data becomes a table of numbers, `data-analysis-methodology` governs the statistics (hypotheses before tests, multiple-comparison traps, honest visualization). Write-ups go to `academic-paper-writing` or `academic-research-slides`. Load this skill alongside those, not instead of them.

## Data handling rules (before any analysis)

- **Analyze only data you are authorized to hold.** Lab sensor data, public research datasets (with their licenses), and captures made on networks you administer or with permission. If provenance is unclear, ask before opening it.
- **Real traffic contains personal data.** Payloads, and often IP addresses themselves, identify people. Keep raw captures in the designated storage, don't paste payload contents or unmasked client addresses into documents/slides/chat, and anonymize (e.g., prefix-preserving) before anything leaves the analysis environment. Darknet data is milder (no legitimate payload) but source addresses still get masked in publications per lab practice.
- **Never modify raw captures.** All work happens on derived files; the raw file plus the extraction script must regenerate every result.

---

## Phase 1 — Establish capture context

Before reading a single packet, determine how the data came to exist; every downstream interpretation depends on it.

1. **Vantage point:** where in the topology was this captured (host, mirror port, middlebox, sensor /24)? What traffic *couldn't* it have seen? A conclusion like "no response was sent" is only valid if the vantage would have seen the response.
2. **Completeness:** run `capinfos` — duration, packet count, dropped-packet count if recorded. Check snaplen: truncated payloads silently break reassembly and DPI-style checks. For flow data, know the sampling rate (1:1000 NetFlow makes small flows invisible and short-flow counts meaningless) and the active/inactive timeout settings, which define what a "flow" even is.
3. **Clock:** single capture — is the timestamp source NIC or kernel, and is the host NTP-synced? Multiple captures — never compare timestamps across files without establishing offset; a common event visible in both is the calibration.
4. **Encapsulation and artifacts:** note VLAN tags, tunnels (GRE/VXLAN/IPIP), and NAT between the traffic and the capture point. Expect checksum-offload artifacts (bad checksums on locally-sent packets) — they are capture-side, not network-side.
5. **Record all of this as the data sheet** at the top of the analysis notes. Papers get rejected — correctly — for missing exactly this.

## Phase 2 — Triage and inventory

1. **Profile before hypothesizing:** protocol hierarchy (`tshark -qz io,phs`), time span and gaps, top talkers, port/protocol distribution, packet size distribution. Ten minutes of profiling prevents hours of analyzing the wrong slice.
2. **Locate the traffic of interest and cut a working set** with a capture filter expression, into a new file (`tshark -r raw.pcap -Y '...' -w subset.pcap`). Name working files by their filter, and record the command that made each.
3. **Sanity-check volume conservation:** subset counts should sum to something consistent with the whole. If 90% of packets match none of your categories, the categorization is wrong, not the traffic.

## Phase 3 — Reduce reproducibly

1. **Extraction is scripts, not clicks.** Wireshark is for looking; conclusions come from scripted extraction so they can be rerun. The workhorse pattern:

   ```
   tshark -r data.pcap -Y '<filter>' -T fields -E separator=, -E header=y \
     -e frame.time_epoch -e ip.src -e ip.dst -e ip.proto \
     -e tcp.srcport -e tcp.dstport -e tcp.flags -e frame.len > out.csv
   ```

   Zeek (`zeek -r data.pcap`) when connection-level logs, service detection, or its protocol analyzers fit better; scapy for per-packet logic that field extraction can't express. Choose the highest-level tool that answers the question.
2. **Aggregate to the right unit early:** packet, flow/connection, source, /24, time bin. Most security questions are per-source or per-flow questions; leaving data at packet granularity invites double counting (retransmissions, fragments).
3. **One pipeline file per question,** raw → fields → aggregate → figure, committed with the analysis. The test: a labmate with the raw data reproduces every number in the report by running the scripts.

## Phase 4 — Darknet (network telescope) interpretation

Darknet sensors receive traffic to unused address space, so there is no legitimate baseline — but that does not make everything "an attack." Classify before characterizing:

1. **Scanning:** SYNs and UDP probes walking ports/addresses. Distinguish horizontal (one port, many addresses) from vertical; extract inter-arrival and address-ordering patterns — they fingerprint the scanner software (e.g., masscan vs. Mirai-family's characteristic sequences).
2. **Backscatter:** responses (SYN-ACK, RST, ICMP unreachable) to packets the sensor never sent — evidence of spoofed-source DoS *elsewhere*, whose victim is the backscatter's source address. Backscatter analysis measures attacks on third parties; keep the direction of inference straight.
3. **Misconfiguration and leakage:** typo'd addresses, stale DNS, internal traffic escaping — low-volume, persistent, boring; exclude it explicitly rather than letting it pollute scan statistics.
4. **Spoofing caveat, always:** the source address of an unsolicited packet is a claim, not a fact. TCP sources that complete no handshake and all UDP sources may be spoofed. Statements like "N hosts are infected" require an argument for why the sources are real (e.g., consistent revisits, handshake completion on a responder, or corroborating dataset).
5. **Sensor bias:** a /24 telescope's view scales with address-space size and its position; Internet-wide extrapolations need explicit scaling assumptions, stated as assumptions. Diurnal and weekly cycles are the norm — "traffic increased" means nothing without comparison against the same phase of the cycle.

## Phase 5 — Characterize attacks and anomalies

1. **Name the phenomenon precisely, using the taxonomy:** volumetric flood (UDP/ICMP), reflection-amplification (DNS/NTP/memcached/SSDP — identifiable by source port and response-heavy asymmetry), TCP state exhaustion (SYN flood), application-layer (needs payload/log visibility, usually invisible in flow data), carpet bombing (victim is a prefix, not a host). "It's DDoS" is not a finding; "NTP reflection at ~X Gbps against victim prefix Y for Z minutes" is.
2. **Extract features that discriminate,** not just describe: pps/bps time series, unique sources per bin, source-address entropy, port concentration, packet-size modes, TTL distribution, flag mixes. For detection research, the feature's value is whether it separates the phenomenon from the sensor's baseline — show both distributions, not just the attack's.
3. **Bound the measurement:** sampled flow data underestimates short attacks; a capture that starts mid-attack has no onset; sensor-relative rates are not victim-experienced rates. Attach the bound to the number ("≥ X pps observed at a 1:100-sampled vantage").

## Phase 6 — Ground truth and labeling

1. **State where labels come from** — IDS alerts, blocklists, honeypot corroboration, manual inspection, synthetic generation — and what that source's own error rate does to the labels. Blocklist-labeled "malicious" sources are a lower bound with unknown precision.
2. **Public datasets (CIC-IDS, MAWI, CAIDA telescope, etc.) have documented flaws** — synthetic attack traffic with tell-tale artifacts, class imbalance, aged protocol mixes. Cite the known critiques; reviewers in this field will.
3. **Never evaluate detection on the data that defined the detector.** Temporal splits (train early / test late) reflect deployment reality; random splits over traffic leak session-level information across the boundary.

## Failure modes to check before delivering

- Data sheet (Phase 1) present, and limitations propagated into the conclusions?
- Every number regenerable from raw data by a script that exists?
- Darknet sources treated as potentially spoofed, or silently trusted?
- Any "increase/anomaly" claim controlled for diurnal/weekly cycles?
- Personal data: no raw addresses or payloads in the deliverable beyond what the lab's publication practice allows?
- Statistics beyond description (tests, models, claims of difference) — was `data-analysis-methodology` actually loaded and followed?
