

## OSI Layers vs TCP/IP Stack – Protocol Mapping

### OSI Model (7 Layers)

- **Layer 1 – Physical**
  - Deals with raw bit transmission over physical media (cables, radio signals).
  - Examples: Fiber optics, Ethernet cables, Wi-Fi signals.

- **Layer 2 – Data Link**
  - Provides node-to-node data transfer and error detection.
  - Examples: Ethernet frames, MAC addresses, PPP.

- **Layer 3 – Network**
  - Handles logical addressing and routing of packets.
  - Examples: IP, ICMP, ARP.

- **Layer 4 – Transport**
  - Ensures reliable or best-effort delivery between hosts.
  - Examples: TCP (reliable), UDP (fast, connectionless).

- **Layer 5 – Session**
  - Manages sessions and dialog control between applications.
  - Examples: NetBIOS, RPC.

- **Layer 6 – Presentation**
  - Translates, encrypts, or compresses data for the application.
  - Examples: SSL/TLS, MIME types.

- **Layer 7 – Application**
  - Provides services directly to end-users or applications.
  - Examples: HTTP, HTTPS, DNS, FTP, SMTP.

---

### TCP/IP Model (4 Layers)

| **OSI Model (7 Layers)** | **TCP/IP Model (4 Layers)** | **Examples / Protocols** |
|---------------------------|-----------------------------|---------------------------|
| Layer 7 – Application     | Application                 | HTTP, HTTPS, DNS, FTP, SMTP |
| Layer 6 – Presentation    | Application                 | SSL/TLS (encryption) |
| Layer 5 – Session         | Application                 | NetBIOS, RPC              |
| Layer 4 – Transport       | Transport                   | TCP, UDP                  |
| Layer 3 – Network         | Internet                    | IP, ICMP           |
| Layer 2 – Data Link       | Link                        | Ethernet, PPP, Wi-Fi      |
| Layer 1 – Physical        | Link                        | Cables, hubs, radio signals |

---

### Protocol Placement
- **IP** → Internet layer (TCP/IP) / Network layer (OSI)  
- **TCP/UDP** → Transport layer  
- **HTTP/HTTPS, DNS** → Application layer  

---

### Real Example
- Running `curl https://example.com` involves:  
  - **Application Layer:** HTTP request  
  - **Transport Layer:** TCP connection  
  - **Internet Layer:** IP routing  
  - **Link Layer:** Ethernet/Wi-Fi delivering packets

---
## Hands-on Networking Checklist
- **Identity:** `hostname -I` (or `ip addr show`) — note your IP.
    ```bash
    hostname -I
    192.168.0.107 
    ```
    - Observation: Shows system IP, e.g., `192.168.0.107`

- **Reachability:** `ping <target>` — mention latency and packet loss.
    ```bash
    ping -c 4 google.com
    PING google.com (172.217.24.142) 56(84) bytes of data.
    64 bytes from lcmaaa-av-in-f14.1e100.net (172.217.24.142): icmp_seq=1 ttl=115 time=33.9 ms
    64 bytes from lcmaaa-av-in-f14.1e100.net (172.217.24.142): icmp_seq=2 ttl=115 time=33.2 ms
    64 bytes from lcmaaa-av-in-f14.1e100.net (172.217.24.142): icmp_seq=3 ttl=115 time=34.8 ms
    64 bytes from lcmaaa-av-in-f14.1e100.net (172.217.24.142): icmp_seq=4 ttl=115 time=34.0 ms

    --- google.com ping statistics ---
    4 packets transmitted, 4 received, 0% packet loss, time 2998ms
    rtt min/avg/max/mdev = 33.213/33.962/34.759/0.547 ms
    ```
    - Observation: Latency ~34ms, 0% packet loss → host reachable.

- **Path:** `traceroute <target>` (or `tracepath`) — note any long hops/timeouts.
    ```bash
    traceroute google.com
    traceroute to google.com (172.217.24.142), 30 hops max, 60 byte packets
    1  _gateway (192.168.0.1)  1.796 ms  1.667 ms  1.579 ms
    2  10.10.60.1 (10.10.60.1)  1.800 ms  1.784 ms  1.515 ms
    3  172.30.1.29 (172.30.1.29)  2.995 ms  3.010 ms  2.921 ms
    4  172.30.6.193 (172.30.6.193)  3.136 ms  3.229 ms  3.139 ms
    5  10.241.1.6 (10.241.1.6)  3.939 ms  4.342 ms  3.490 ms
    6  10.240.254.140 (10.240.254.140)  1.215 ms  1.298 ms  1.203 ms
    7  10.240.254.1 (10.240.254.1)  3.588 ms  3.139 ms  3.406 ms
    8  10.241.1.1 (10.241.1.1)  3.027 ms * *
    9  172.30.6.166 (172.30.6.166)  2.358 ms  2.127 ms *
    10  172.30.6.210 (172.30.6.210)  1.172 ms  1.083 ms  1.021 ms
    11  110.172.55.177 (110.172.55.177)  1.238 ms  2.131 ms  1.893 ms
    12  ns0.wishnet.in (223.223.158.197)  34.820 ms  34.217 ms  33.363 ms
    13  * * *
    14  142.251.55.60 (142.251.55.60)  32.205 ms 142.251.49.218 (142.251.49.218)  32.868 ms 142.250.228.222 (142.250.228.222)  35.215 ms
    15  142.251.55.89 (142.251.55.89)  33.215 ms  32.924 ms 142.251.230.70 (142.251.230.70)  32.426 ms
    16  syd09s06-in-f14.1e100.net (172.217.24.142)  32.698 ms 142.251.51.119 (142.251.51.119)  34.097 ms lcmaaa-av-in-f14.1e100.net (172.217.24.142)  34.390 ms
    [student@fedora]~% 

    ```
    - Observation: ~16 hops, connection is very stable. There is no significant congestion within ISP, and the path to Google is efficient with a consistent 33ms response time..

- **Ports:** `ss -tulpn` (or `netstat -tulpn`) — list one listening service and its port.
    ```bash
    ss -tulpn | grep 22
    udp   UNCONN 0      0                                 0.0.0.0:60545      0.0.0.0:*    users:(("wsdd",pid=5222,fd=8)) 
    udp   UNCONN 0      0                           192.168.0.107:3702       0.0.0.0:*    users:(("wsdd",pid=5222,fd=9)) 
    udp   UNCONN 0      0                         239.255.255.250:3702       0.0.0.0:*    users:(("wsdd",pid=5222,fd=7)) 
    udp   UNCONN 0      0                                       *:35328            *:*    users:(("wsdd",pid=5222,fd=11))
    udp   UNCONN 0      0      [fe80::fae2:285c:22f4:bad7]%ens160:3702          [::]:*    users:(("wsdd",pid=5222,fd=12))
    udp   UNCONN 0      0                        [ff02::c]%ens160:3702          [::]:*    users:(("wsdd",pid=5222,fd=10))
    tcp   LISTEN 0      128                               0.0.0.0:22         0.0.0.0:*                                   
    tcp   LISTEN 0      128                                  [::]:22            [::]:*         
    ```
    - Observation: Found SSH service listening on port 22.

- **Name resolution:** `dig <domain>` or `nslookup <domain>` — record the resolved IP.
    ```bash
    dig google.com

    ; <<>> DiG 9.18.28 <<>> google.com
    ;; global options: +cmd
    ;; Got answer:
    ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 41786
    ;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

    ;; OPT PSEUDOSECTION:
    ; EDNS: version: 0, flags:; udp: 65494
    ;; QUESTION SECTION:
    ;google.com.			IN	A

    ;; ANSWER SECTION:
    google.com.		196	IN	A	172.217.24.142

    ;; Query time: 3 msec
    ;; SERVER: 127.0.0.53#53(127.0.0.53) (UDP)
    ;; WHEN: Sat Feb 07 16:42:16 IST 2026
    ;; MSG SIZE  rcvd: 55

    ```
    - Observation: Resolved IP → `172.217.24.142`

- **HTTP check:** `curl -I <http/https-url>` — note the HTTP status code.
    ```bash
    curl -IL https://google.com
    HTTP/2 301 
    location: https://www.google.com/
    content-type: text/html; charset=UTF-8
    content-security-policy-report-only: object-src 'none';base-uri 'self';script-src 'nonce-cadQBKG7XhnU-AZdCN0xJA' 'strict-dynamic' 'report-sample' 'unsafe-eval' 'unsafe-inline' https: http:;report-uri https://csp.withgoogle.com/csp/gws/other-hp
    reporting-endpoints: default="//www.google.com/httpservice/retry/jserror?ei=ZR-HabOaN-XPkPIPv8yFgAc&cad=crash&error=Page%20Crash&jsel=1"
    date: Sat, 07 Feb 2026 11:17:57 GMT
    expires: Mon, 09 Mar 2026 11:17:57 GMT
    cache-control: public, max-age=2592000
    server: gws
    content-length: 220
    x-xss-protection: 0
    x-frame-options: SAMEORIGIN
    alt-svc: h3=":443"; ma=2592000,h3-29=":443"; ma=2592000

    HTTP/2 200 
    content-type: text/html; charset=ISO-8859-1
    content-security-policy-report-only: object-src 'none';base-uri 'self';script-src 'nonce-Arm2AzZ3G7qqj96drWa-Fg' 'strict-dynamic' 'report-sample' 'unsafe-eval' 'unsafe-inline' https: http:;report-uri https://csp.withgoogle.com/csp/gws/other-hp
    reporting-endpoints: default="//www.google.com/httpservice/retry/jserror?ei=Zh-HacexD6jckPIP2PKm2A4&cad=crash&error=Page%20Crash&jsel=1"
    accept-ch: Sec-CH-Prefers-Color-Scheme
    p3p: CP="This is not a P3P policy! See g.co/p3phelp for more info."
    date: Sat, 07 Feb 2026 11:17:58 GMT
    server: gws
    x-xss-protection: 0
    x-frame-options: SAMEORIGIN
    expires: Sat, 07 Feb 2026 11:17:58 GMT
    cache-control: private
    set-cookie: AEC=AaJma5tR8v5pWsxEdIFfg9PYvEXuyE3qlgNcdOZiPCLl5iFT3M6so3iCqJs; expires=Thu, 06-Aug-2026 11:17:58 GMT; path=/; domain=.google.com; Secure; HttpOnly; SameSite=lax
    set-cookie: NID=528=YxRw8BFly17hqmUZUZxtoZMkxMp8Il6sddOj6DI4CUBUNGSsEP6zznYTVQDQ4oXU5thHvLF25IQP4g4GSXaBwJeK_sJE-YL8CbfY_A38pwrzLqD6y_N4Ar5VgnccaRzVvuqdUkAykAL_oiqbKdcxnkUsF3mWYxSWwwRFAQrewXgqUC1nkwLUN8pZgWoJtAmQENrOaZCjCVc3smXlsQ3fGgemqdIazg; expires=Sun, 09-Aug-2026 11:17:58 GMT; path=/; domain=.google.com; HttpOnly
    set-cookie: __Secure-BUCKET=CL8E; expires=Thu, 06-Aug-2026 11:17:58 GMT; path=/; domain=.google.com; Secure; HttpOnly
    alt-svc: h3=":443"; ma=2592000,h3-29=":443"; ma=2592000

    ```
    - Observation: Returned `HTTP/2 200  OK`

- **Connections snapshot:** `netstat -an | head` — count ESTABLISHED vs LISTEN (rough).
    ```bash
    netstat -an | head
    Active Internet connections (servers and established)
    Proto Recv-Q Send-Q Local Address           Foreign Address         State      
    tcp        0      0 127.0.0.53:53           0.0.0.0:*               LISTEN     
    tcp        0      0 127.0.0.1:631           0.0.0.0:*               LISTEN     
    tcp        0      0 0.0.0.0:27500           0.0.0.0:*               LISTEN     
    tcp        0      0 0.0.0.0:5355            0.0.0.0:*               LISTEN     
    tcp        0      0 127.0.0.54:53           0.0.0.0:*               LISTEN     
    tcp        0      0 127.0.0.1:11434         0.0.0.0:*               LISTEN     
    tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN     
    tcp        0      0 192.168.0.107:55964     98.91.54.208:443        ESTABLISHED

    ```
    - Observation: 1 ESTABLISHED connections, 7 LISTEN sockets

Pick one target service/host (e.g., `google.com`, your lab server, or a local service) and stick to it for ping/traceroute/curl where possible.

---
## Mini Task: Port Probe & Interpret (AWS EC2 – Ubuntu + Nginx)

### Step 1: Identify Listening Port
Run:
```bash
ss -tulpn

```
- Observation: Nginx is typically listening on port 80 (HTTP) or 443 (HTTPS).
- Example output: tcp   LISTEN  0  511   [::]:80  [::]:*

### Step 2: Test Port Reachability
Run:
```bash
curl -I http://localhost:80

HTTP/1.1 200 OK
Server: nginx/1.24.0 (Ubuntu)
Date: Sat, 07 Feb 2026 11:53:33 GMT
Content-Type: text/html
Content-Length: 615
Last-Modified: Sat, 07 Feb 2026 11:42:03 GMT
Connection: keep-alive
ETag: "6987250b-267"
Accept-Ranges: bytes
```
- - Observation: If reachable, we’ll see Connection succeeded or an HTTP status code (e.g., 200 OK).

### Step 3: Interpret Result
- **Reachable:** Service is running and responding.
- **Not Reachable:** Next checks should be: 
    - Verify Nginx service status: `systemctl status nginx`
    - Check firewall/security group rules (AWS EC2 inbound rules for port 80/443).
    - Inspect Nginx configuration for binding issues.
---
## Networking Troubleshooting Reflection

**Which command gives you the fastest signal when something is broken?**
- **Ping** gives the quickest indication of reachability issues.  
- If packets fail or latency spikes, it’s an immediate sign of a connectivity problem.


**What layer (OSI/TCP-IP) would you inspect next if DNS fails? If HTTP 500 shows up?**
- **If DNS fails:** Inspect the **Internet/Network layer** (IP resolution, routing).  
- **If HTTP 500 shows up:** Inspect the **Application layer** (web server/service logs).

**Two follow-up checks you’d run in a real incident.**
1. **Service Status:** Verify if the target service is running (`systemctl status <service>`).  
2. **Firewall/Access Rules:** Check firewall settings or security groups to confirm ports are open and accessible.
---
