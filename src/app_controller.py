from protocol import MessageType
from network_manager import NetworkManager
from console_ui import ConsoleUI
from file_transfer import FileTransferManager
from message_handler import MessageHandler

class AppController:
    def __init__(self,interface):
        self.network = NetworkManager(interface)
        self.file_transfer = FileTransferManager(self.network)
        self.ui = ConsoleUI(self)
        self.message_handler =  MessageHandler(self.ui,self.file_transfer)

        self.network.register_callback(self.message_handler.handle_incoming_message)
    def start_application(self):
        if not self.network.start():
            print("Error iniciando servicios de red")
            return False
        
        self.ui.start_interactive_mode()
        return True
    
    def send_text_message(self,dest_mac,message):
        return self.network.send_message(dest_mac,MessageType.Message,message)
    
    def send_file(self,dest_mac,file_path):
        return self.file_transfer.send_file(dest_mac,file_path)

    def get_mac_address(self):
        return self.network.socket_manager.mac_address
    
    def shutdown(self):
        return self.network.stop()