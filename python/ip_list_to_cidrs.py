import ipaddress

ip_list = []
with open("ip.txt", "r", encoding="utf-8") as f:
    line = f.readline()
    while line:
        ip_list.append(line.strip())
        line = f.readline()

nets = [ipaddress.ip_network(_ip) for _ip in ip_list]
cidrs = ipaddress.collapse_addresses(nets)
for k, v in enumerate(cidrs):
    print(v)
