import time
from protocol import MessageType

class MessageHandler:
    #Faltaria pasar como parametro un controlador para transferenica de archivos
    def __init__(self,ui):
        self.ui = ui
    
    def handle_incoming_message(self,src_mac,msg_type,data):
        if msg_type == MessageType.Message:
            self.handle_text_message(src_mac,data)
        #Falta manejar casos de transferencia de archivos
        elif msg_type == MessageType.Discovery:
            self.handle_discovery_response(src_mac,data)
    
    def handle_text_message(self,src_mac,data):
        try:
            message = data.decode('utf-8')
            self.ui.display_message(src_mac,message)
        except:
            print(f"Error decodificando mensajes de {src_mac}")
    
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