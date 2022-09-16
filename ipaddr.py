import subprocess  # for running external programs
from ipaddress import IPv4Address # for converting the strings to IPV4 address

# determine the class of the ip address

def addrType(ipaddr):
    if (ipaddr.is_loopback):
        print("This is the loopback address")
        return
    elif (ipaddr.is_multicast):
        print("This is Class D multicast address")
        return
    elif (ipaddr.is_reserved):
        print("This is a reserved IP address for research purposes")
        return
    elif (ipaddr.is_unspecified):
        print("This is a special IP address")
        return
    elif (ipaddr <= IPv4Address("127.0.0.0")):
        if (ipaddr.is_private):
            print("This is a Class A Private IP address")
            return
        else:
            print("This is a Class A Public IP address")
            return
    elif (ipaddr <= IPv4Address("191.255.255.255")):
        if (ipaddr.is_private):
            print("This is a Class B Private IP address")
            return
        else:
            print("This is a Class B Public IP address")
            return
    elif (ipaddr <= IPv4Address("223.255.255.255")):
        if (ipaddr.is_private):
            print("This is a Class C Private IP address")
            return
        else:
            print("This is a Class C Public IP address")
            return

# ping ip read from stdout

def pingAddr(ipaddr):
    print(f"Pinging {ipaddr}...")
    ping_out = subprocess.run(["ping", "-c4", f"{ipaddr}"],
                              capture_output=True, text=True)
    text = ping_out.stdout

    # if ip cannot be pinged stop script and don't run traceroute
    if ("timeout" not in text):
        print(f"{ipaddr} was pinged successfully")

    else:
        print(f"{ipaddr} cannot be pinged successfully")
        exit()


# run traceroute on ip and store data in a file

def traceAddr(ipaddr):
    print(f"Counting hops to {ipaddr}")
    trace_out = subprocess.run([f"traceroute {ipaddr} | grep {ipaddr} "],
                               capture_output=True, text=True, shell=True)
    text2 = trace_out.stdout

    print(f"There are {text2[0:3]}hops to {ipaddr}")


# Get IP address
ipaddr = IPv4Address(input("Please provide ipaddress:"))
addrType(ipaddr)
pingAddr(ipaddr)
traceAddr(ipaddr)
