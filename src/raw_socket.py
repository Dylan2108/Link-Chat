# pyright: reportMissingImports=false
# pyright: reportPossiblyUnboundVariable=false
# type: ignore

import platform
import socket
from protocol import Protocol

try:
    if platform.system() == "Windows":
        import scapy.all as scapy

        SCAPY_AVAILABLE = True
    else:
        import netifaces

        scapy = None
        SCAPY_AVAILABLE = False
except ImportError:
    scapy = None
    SCAPY_AVAILABLE = False


class RawSocketHandler:
    def __init__(self):
        self.system = platform.system()
        self.interfaces = self.list_interfaces()
        self.interface = ""
        self.mac_address = ""
        self.socket = None

    def list_interfaces(self):
        interfaces = []
        try:
            if self.system == "Windows" and SCAPY_AVAILABLE:
                for iface in scapy.get_if_list():
                    try:
                        mac = scapy.get_if_hwaddr(iface)
                        interfaces.append((iface, mac))
                    except Exception:
                        interfaces.append((iface, "desconocida"))
            else:
                for iface in netifaces.interfaces():
                    try:
                        addrs = netifaces.ifaddresses(iface)
                        if netifaces.AF_LINK in addrs:
                            mac = addrs[netifaces.AF_LINK][0]["addr"]
                            interfaces.append((iface, mac))
                    except Exception:
                        interfaces.append((iface, "desconocida"))
        except ImportError:
            print("Faltan dependencias: instala 'netifaces' o 'scapy'")

        return interfaces

    def get_mac_address(self):
        try:
            if self.system == "Windows" and SCAPY_AVAILABLE:
                return scapy.get_if_hwaddr(self.interface)
            elif scapy is None:  # Non-windows, use netifaces
                addrs = netifaces.ifaddresses(self.interface)
                if netifaces.AF_LINK in addrs:
                    return addrs[netifaces.AF_LINK][0]["addr"]
        except Exception:
            return "00:00:00:00:00:00"
        return "00:00:00:00:00:00"

    def create_socket(self, interface):
        self.interface = interface
        self.mac_address = self.get_mac_address()
        if self.system == "Windows" and SCAPY_AVAILABLE:
            if self.interface not in scapy.get_if_list():
                return False
            return True
        else:
            try:
                self.socket = socket.socket(
                    socket.Af_PACKET, socket.SOCK_RAW, socket.htons(Protocol.ETH_TYPE)
                )
                self.socket.bind((self.interface, 0))
                return True
            except Exception as e:
                print(f"Error: {e}")
                return False

    def send_frame(self, frame):
        if self.system == "Windows" and SCAPY_AVAILABLE:
            try:
                scapy.sendp(scapy.Ether(frame), iface=self.interface, verbose=False)
                return True
            except Exception as e:
                print(f"Error: {e}")
                return False
        elif self.socket:
            try:
                return self.socket.send(frame)
            except Exception as e:
                print(f"Error: {e}")
                return False
        return False

    def receive_frame(self):
        if self.system == "Windows" and SCAPY_AVAILABLE:
            try:
                pkts = scapy.sniff(iface=self.interface, count=1, timeout=1)
                if pkts:
                    return bytes(pkts[0])
                return None
            except Exception as e:
                print(f"Error: {e}")
                return None
        elif self.socket:
            try:
                frame, _ = self.socket.recvfrom(65536)
                return frame
            except Exception as e:
                print(f"Error: {e}")
                return None
        return None

    def close(self):
        if self.socket:
            self.socket.close()
