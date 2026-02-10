
# Networking Fundamentals: DNS, IPs & Ports Simplified

## Task 1: DNS – How Names Become IPs

**1. Explain in 3–4 lines: what happens when you type `google.com` in a browser?**
- When we type `google.com` in a browser, the request goes to a **recursive DNS resolver**, which first asks a **Root DNS server** where to find `.com` domains. The resolver then queries the **TLD (.com) DNS servers**, which point to Google’s **authoritative DNS servers**. These authoritative servers return the actual **A record (IP address)**, and the browser uses it to connect to Google’s server and load the webpage.

**Browser** → **Local Cache** → **Recursive Resolver** → **Root DNS** → **.com TLD DNS** → **Google’s Authoritative DNS** → **IP Address** → **Connect to Google Server** → **Webpage**

---
**2. What are these record types? Write one line each:**
   - `A`, `AAAA`, `CNAME`, `MX`, `NS`

| Record Type | Description |
|-------------|-------------|
| **A**       | Maps a domain name to an IPv4 address. |
| **AAAA**    | Maps a domain name to an IPv6 address. |
| **CNAME**   | Creates an alias from one domain name to another. |
| **MX**      | Specifies mail servers responsible for receiving emails for the domain. |
| **NS**      | Defines the authoritative name servers for the domain. |
---


**3. Run: `dig google.com` — identify the A record and TTL from the output**
    ```bash
    dig google.com

    ; <<>> DiG 9.18.28 <<>> google.com
    ;; global options: +cmd
    ;; Got answer:
    ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 6397
    ;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

    ;; OPT PSEUDOSECTION:
    ; EDNS: version: 0, flags:; udp: 65494
    ;; QUESTION SECTION:
    ;google.com.			IN	A

    ;; ANSWER SECTION:
    google.com.		298	IN	A	142.250.183.174

    ;; Query time: 4 msec
    ;; SERVER: 127.0.0.53#53(127.0.0.53) (UDP)
    ;; WHEN: Tue Feb 10 08:44:43 IST 2026
    ;; MSG SIZE  rcvd: 55
    ```
- **A record** - `142.250.183.174`
- **TTL** - `298 ms`

---

## Task 2: IP Addressing

**1. What is an IPv4 address? How is it structured? (e.g., `192.168.1.10`)**
- An **IPv4 address** is a unique identifier assigned to every device connected to a network that uses IPv4 for communication. It ensures that data packets know **where to come from** and **where to go**. 

IPv4 addresses serve two main purposes:
- **Identification**: Uniquely identifies a device on a network.
- **Location addressing**: Specifies where the device is located in the network, enabling proper routing of data.

**Structure of IPv4 Address**
- IPv4 uses a **32-bit number**, divided into **four octets** (8 bits each).
- Each octet is represented in **decimal format** (0–255) and separated by dots.
- Example: `192.168.1.10`  
  - Binary form: `11000000.10101000.00000001.00001010`  
  - Decimal form: `192.168.1.10`

Thus, IPv4 addresses range from `0.0.0.0` to `255.255.255.255`.

---

**2. Difference between **public** and **private** IPs — give one example of each**
- **Public IP**: Used to identify devices on the wider internet. Example: `142.250.183.174` (Google’s server).  
- **Private IP**: Used within local networks (home, office). Example: `192.168.0.107`.  

---
**3. What are the private IP ranges?**
   - `10.x.x.x`, `172.16.x.x – 172.31.x.x`, `192.168.x.x`

The Internet Assigned Numbers Authority (IANA) reserves specific ranges for private networks:

- `10.0.0.0` – `10.255.255.255` (10.x.x.x)  
- `172.16.0.0` – `172.31.255.255` (172.16.x.x – 172.31.x.x)  
- `192.168.0.0` – `192.168.255.255` (192.168.x.x)  

These ranges are **not routable on the public internet** and are only used inside private networks.
---
4. Run: `ip addr show` — identify which of your IPs are private
```bash
ip addr show
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host proto kernel_lo 
       valid_lft forever preferred_lft forever
2: ens160: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 00:50:56:2a:2a:ae brd ff:ff:ff:ff:ff:ff
    altname enp3s0
    inet 192.168.0.107/24 brd 192.168.0.255 scope global dynamic noprefixroute ens160
       valid_lft 6022sec preferred_lft 6022sec
    inet6 fe80::fae2:285c:22f4:bad7/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
3: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default 
    link/ether 02:42:f2:62:67:df brd ff:ff:ff:ff:ff:ff
```
Private IP Address: `192.168.0.107`

---

## Task 3: CIDR & Subnetting
**1. What does `/24` mean in `192.168.1.0/24`?**

The `/24` is a **CIDR (Classless Inter-Domain Routing) notation** that indicates the subnet mask.  
- `/24` means the first 24 bits of the IP address are reserved for the network portion.  
- This corresponds to a subnet mask of `255.255.255.0`.  
- The remaining 8 bits are used for host addresses.
---

**2. How many usable hosts in a `/24`? A `/16`? A `/28`?**
- **/24** → Total IPs = 256, Usable Hosts = 254  
- **/16** → Total IPs = 65,536, Usable Hosts = 65,534  
- **/28** → Total IPs = 16, Usable Hosts = 14  

*(Usable hosts = Total IPs – 2, because one address is reserved for the network ID and one for the broadcast address.)*

---
**3. Explain in your own words: why do we subnet?**

Subnetting divides a large network into smaller, manageable segments.  
- It improves **network efficiency** by reducing broadcast traffic.  
- It enhances **security** by isolating groups of devices.  
- It allows better **IP address utilization**, ensuring addresses aren’t wasted.  
In short, subnetting helps organize and optimize networks.

---
**4. Quick exercise — fill in:**

| CIDR | Subnet Mask     | Total IPs | Usable Hosts |
|------|-----------------|-----------|--------------|
| /24  | 255.255.255.0   | 256       | 254          |
| /16  | 255.255.0.0     | 65,536    | 65,534       |
| /28  | 255.255.255.240 | 16        | 14           |


---

## Task 4: Ports – The Doors to Services
**1. What is a port? Why do we need them?**

A **port** is a logical endpoint in networking that helps identify specific processes or services running on a device.  
- If IP address is the "street address" of a computer, and ports are the "apartment numbers" inside that building.  
- Ports allow multiple services (like web, email, SSH) to run on the same machine without confusion.  
- They are essential for directing network traffic to the correct application.

---

**2. Document these common ports:**

| Port | Service              |
|------|----------------------|
| 22   | SSH (Secure Shell)   |
| 80   | HTTP (Web traffic)   |
| 443  | HTTPS (Secure Web)   |
| 53   | DNS (Domain Name System) |
| 3306 | MySQL Database       |
| 6379 | Redis (In-memory data store) |
| 27017| MongoDB Database     |

---

3. Run `ss -tulpn` — match at least 2 listening ports to their services
```bash
ss -tulpn            
Netid              State               Recv-Q              Send-Q                                                Local Address:Port                              Peer Address:Port              Process                                       
udp                UNCONN              0                   0                                                         127.0.0.1:323                                    0.0.0.0:*                                                               
udp                UNCONN              0                   0                                                           0.0.0.0:5353                                   0.0.0.0:*                                                               
udp                UNCONN              0                   0                                                           0.0.0.0:5355                                   0.0.0.0:*                                                               
udp                UNCONN              0                   0                                                           0.0.0.0:47959                                  0.0.0.0:*                  users:(("wsdd",pid=5222,fd=8))               
udp                UNCONN              0                   0                                                     192.168.0.107:3702                                   0.0.0.0:*                  users:(("wsdd",pid=5222,fd=9))               
udp                UNCONN              0                   0                                                   239.255.255.250:3702                                   0.0.0.0:*                  users:(("wsdd",pid=5222,fd=7))               
udp                UNCONN              0                   0                                                           0.0.0.0:36797                                  0.0.0.0:*                                                               
udp                UNCONN              0                   0                                                        127.0.0.54:53                                     0.0.0.0:*                                                               
udp                UNCONN              0                   0                                                     127.0.0.53%lo:53                                     0.0.0.0:*                                                               
udp                UNCONN              0                   0                                                             [::1]:323                                       [::]:*                                                               
udp                UNCONN              0                   0                                                              [::]:5353                                      [::]:*                                                               
udp                UNCONN              0                   0                                                              [::]:5355                                      [::]:*                                                               
udp                UNCONN              0                   0                                                                 *:38565                                        *:*                  users:(("wsdd",pid=5222,fd=11))              
udp                UNCONN              0                   0                                [fe80::fae2:285c:22f4:bad7]%ens160:3702                                      [::]:*                  users:(("wsdd",pid=5222,fd=12))              
udp                UNCONN              0                   0                                                  [ff02::c]%ens160:3702                                      [::]:*                  users:(("wsdd",pid=5222,fd=10))              
udp                UNCONN              0                   0                                                              [::]:40702                                     [::]:*                                                               
tcp                LISTEN              0                   4096                                                  127.0.0.53%lo:53                                     0.0.0.0:*                                                               
tcp                LISTEN              0                   4096                                                      127.0.0.1:631                                    0.0.0.0:*                                                               
tcp                LISTEN              0                   10                                                          0.0.0.0:27500                                  0.0.0.0:*                                                               
tcp                LISTEN              0                   4096                                                        0.0.0.0:5355                                   0.0.0.0:*                                                               
tcp                LISTEN              0                   4096                                                     127.0.0.54:53                                     0.0.0.0:*                                                               
tcp                LISTEN              0                   4096                                                      127.0.0.1:11434                                  0.0.0.0:*                                                               
tcp                LISTEN              0                   128                                                         0.0.0.0:22                                     0.0.0.0:*                                                               
tcp                LISTEN              0                   511                                                         0.0.0.0:80                                     0.0.0.0:*                                                               
tcp                LISTEN              0                   4096                                                          [::1]:631                                       [::]:*                                                               
tcp                LISTEN              0                   4096                                                           [::]:5355                                      [::]:*                                                               
tcp                LISTEN              0                   128                                                            [::]:22                                        [::]:*                                                               
tcp                LISTEN              0                   511                                                            [::]:80                                        [::]:*  
```

- **ssh**: `22`
- **http**: `80`

---

## What I learned 

1. **DNS & IP Basics**  
   - Domains like `google.com` are translated into IP addresses through DNS resolution, involving **root servers**, **TLD servers**, and **authoritative servers**.  
   - IPv4 addresses are 32-bit identifiers written in dotted decimal format (e.g., `192.168.1.10`).

2. **Subnetting & CIDR**  
   - CIDR notation (e.g., `/24`) defines how many bits are reserved for the network.  
   - Subnetting improves efficiency, security, and address utilization.  
   - Example: `/24` allows 254 usable hosts, `/16` allows 65,534, and `/28` allows 14.

3. **Ports & Services**  
   - Ports act like “channels” that direct traffic to the correct service on a device.  
   - Common ports: `22` (SSH), `80` (HTTP), `443` (HTTPS), `53` (DNS), `3306` (MySQL), `6379` (Redis), `27017` (MongoDB).

---