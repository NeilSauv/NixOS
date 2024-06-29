{ pkgs ? import <nixpkgs> {} }:

with pkgs; [
  nmap
  wireshark
  john
  aircrack-ng
  metasploit
  hydra-cli
  hashcat
  sqlmap
  ettercap
  nikto
  dnsenum
  burpsuite
  tcpdump
  tcpflow
  radare2
  binwalk
  volatility
]

