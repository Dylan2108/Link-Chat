import socket
import os
from protocol import Protocol


class RawSocketHandler:
    def __init__(self, interface="ens33"):
        self.interface = interface
        self.socket = None
        self.mac_address = self.get_mac_address()

    def get_mac_address(self):
        # Obtiene la direccion Mac de la interfaz
        try:
            with open(f"/sys/class/net/{self.interface}/address", "r") as f:
                return f.read().strip()
        except:
            return "00:00:00:00:00:00"

    def create_socket(self):
        # Crea Socket-Raw
        try:
            self.socket = socket.socket(
                socket.AF_PACKET, socket.SOCK_RAW, socket.htons(Protocol.ETH_TYPE)
            )
            self.socket.bind((self.interface, 0))
            return True
        except Exception as e:
            print(f"Error: {e}")
            return False

    def send_frame(self, frame):
        # Envio directo de frame
        if self.socket:
            try:
                return self.socket.send(frame)
            except Exception as e:
                print(f"Error enviando: {e}")
                return 0
        return 0

    def receive_frame(self):
        # Recepcion de frame
        if self.socket:
            try:
                return self.socket.recvfrom(65536)
            except Exception as e:
                return None, None
        return None, None

    def close(self):
        # Cerrar socket
        if self.socket:
            self.socket.close()
