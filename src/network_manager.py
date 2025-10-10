import threading
from raw_socket import RawSocketHandler
from protocol import Protocol , MessageType
from frame_builder import FrameBuilder
from discovery import NetworkDiscovery

class NetworkManager:
    def __init__(self,interface):
        self.socket_manager = RawSocketHandler(interface)
        self.frame_builder = FrameBuilder()
        self.discovery = NetworkDiscovery(self.socket_manager,self.frame_builder)
        self.running = False
        self.message_callbacks = []

    def start(self):
        #Iniciar servicios de red
        if not self.socket_manager.create_socket():
            return False
        self.running = True

        #Hilo de recepcion
        self.receive_thread = threading.Thread(target=self.receive_loop)
        self.receive_thread.daemon = True
        self.receive_thread.start()

        return True
    
    def receive_loop(self):
        #Bucle de recepcion
        while self.running:
            frame , addr = self.socket_manager.receive_frame()
            if frame:
                self._process_frame(frame)
            
    def _process_frame(self,frame):
        #Procesar Frame
        # print("Procesando frame")
        parsed_frame = self.frame_builder.parse_ethernet_frame(frame)
        if not parsed_frame or parsed_frame['eth_type'] != Protocol.ETH_TYPE:
            return
        
        parsed_message = Protocol.parse_message(parsed_frame['payload'])
        if not parsed_message:
            return
        
        src_mac = parsed_frame['src_mac']
        msg_type = parsed_message['type']
        data = parsed_message['data']
        
        if msg_type == MessageType.Discovery:
            self.discovery.handle_discovery_response(data)
            print("Dispositivo encontrado")
            self.send_discovery_response(src_mac)
            return
        
        if msg_type == MessageType.Discovery_Response:
            self.discovery.handle_discovery_response(data)
            print("Dispostivo encontrado")
            return
        
        if msg_type == MessageType.ACK:
            print("Mensaje enviado correctamente")
            return
        
        #Notificar a callbacks registrados
        for callback in self.message_callbacks:
            try:
                callback(src_mac,msg_type,data)
                self.send_message(src_mac,MessageType.ACK,"Mensaje Recibido")
            except Exception as e:
                print(f"Error en callback : {e}")
    
    def send_discovery_response(self,dest_mac):
        discovery_data = f"Discovery:{self.socket_manager.mac_address}"
        self.send_message(dest_mac,MessageType.Discovery_Response,discovery_data)
    
    def send_message(self,dest_mac,message_type,data):
        #Enviar mensaje
        payload = Protocol.create_message(message_type,data)
        frame = self.frame_builder.build_ethernet_frame(
            dest_mac,
            self.socket_manager.mac_address,
            Protocol.ETH_TYPE,
            payload
        )
        return self.socket_manager.send_frame(frame)
    
    def register_callback(self,callback):
        #Registrar callback para mensajes recibidos
        self.message_callbacks.append(callback)
    
    def stop(self):
        #Detener servicios
        self.running = False
        self.socket_manager.close()