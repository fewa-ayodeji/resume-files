#!/usr/bin/env python3
"""
Module for pinging an IP address and determining its class
"""
import sys
import subprocess  # for running external programs
from ipaddress import IPv4Address


def addr_type(ip_addr):
    """Determine the class of the IP address"""
    if ip_addr.is_loopback:
        print("This is the loopback address")
        return
    if ip_addr.is_multicast:
        print("This is Class D multicast address")
        return
    if ip_addr.is_reserved:
        print("This is a reserved IP address for research purposes")
        return
    if ip_addr.is_unspecified:
        print("This is a special IP address")
        return
    if ip_addr <= IPv4Address("127.0.0.0"):
        if ip_addr.is_private:
            print("This is a Class A Private IP address")
            return
        print("This is a Class A Public IP address")
        return
    elif ip_addr <= IPv4Address("191.255.255.255"):
        if ip_addr.is_private:
            print("This is a Class B Private IP address")
            return
        print("This is a Class B Public IP address")
        return
    elif ip_addr <= IPv4Address("223.255.255.255"):
        if ip_addr.is_private:
            print("This is a Class C Private IP address")
            return
        print("This is a Class C Public IP address")
        return


def ping_addr(ip_addr):
    """Ping IP read from stdout"""
    print(f"Pinging {ip_addr}...")
    ping_out = subprocess.run(["ping", "-c4", f"{ip_addr}"],
                              check=False, capture_output=True, text=True)
    text = ping_out.stdout

    # if IP cannot be pinged stop script and don't run traceroute
    if "timeout" not in text:
        print(f"{ip_addr} was pinged successfully")
    else:
        print(f"{ip_addr} cannot be pinged successfully")
        sys.exit(1)


def trace_addr(ip_addr):
    """Run traceroute on IP and store data in a file"""
    print(f"Counting hops to {ip_addr}")
    trace_out = subprocess.run([f"traceroute {ip_addr} | grep {ip_addr} "],
                               check=False, capture_output=True, text=True, shell=True)
    text2 = trace_out.stdout

    print(f"There are {text2[0:3]}hops to {ip_addr}")


# Get IP address
IP_ADDR = IPv4Address(input("Please provide ip address: "))
addr_type(IP_ADDR)
ping_addr(IP_ADDR)
trace_addr(IP_ADDR)
