import time
from protocol import Protocol , MessageType
from raw_socket import RawSocketHandler
from frame_builder import FrameBuilder

class NetworkDiscovery:
    def __init__(self,socket_manager,frame_builder):
        self.socket_manager = socket_manager
        self.frame_builder = frame_builder
        self.peers = {}

    def broadcast_discovery(self):
        #Envia mensaje de descurimiento
        broadcast_mac = 'ff:ff:ff:ff:ff:ff'
        discovery_data = f"Discovery:{self.socket_manager.mac_address}"

        payload = Protocol.create_message(MessageType.Discovery,discovery_data)

        frame = self.frame_builder.build_ethernet_frame(
            broadcast_mac,
            self.socket_manager.mac_address,
            Protocol.ETH_TYPE,
            payload
        )

        return self.socket_manager.send_frame(frame)
    
    def handle_discovery_response(self,src_mac,data):
        #Manejar respuesta de descubrimiento
        try:
            discovery_data = data.decode('utf-8')
            if discovery_data.startswith('Discovery:'):
                peer_mac = discovery_data.split('Discovery:')[1]
                if peer_mac != src_mac:
                    print("Error en la MAC")
                
                self.peers[peer_mac] = time.time()
                return True
        except:
            pass
        return False