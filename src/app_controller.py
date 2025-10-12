from protocol import MessageType
from network_manager import NetworkManager
from file_transfer import FileTransferManager
from message_handler import MessageHandler


class AppController:
    def __init__(self, ui):
        self.network = NetworkManager()
        self.file_transfer = FileTransferManager(ui, self.network)
        self.message_handler = MessageHandler(ui, self.file_transfer)

        self.network.register_callback(self.message_handler.handle_incoming_message)

    def start_application(self, interface):
        if not self.network.start(interface):
            print("Error iniciando servicios de red")
            return False
        return True

    def list_interfaces(self):
        return self.network.socket_manager.interfaces

    def send_text_message(self, dest_mac, message):
        return self.network.send_message(dest_mac, MessageType.Message, message)

    def send_file(self, dest_mac, file_path):
        return self.file_transfer.send_file(dest_mac, file_path)

    def discover_peers(self):
        return self.network.discovery.broadcast_discovery()

    def discovered_peers(self):
        return self.network.discovery.peers

    def get_mac_address(self):
        return self.network.socket_manager.mac_address

    def shutdown(self):
        return self.network.stop()
