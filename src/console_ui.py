class ConsoleUI:
    def __init__(self,app_controller):
        self.controller = app_controller
    
    def start_interactive_mode(self):
        print("Aplicacion de Mensajeria")
        print(f"MAC Address:{self.controller.get_mac_address()}")
        self.display_menu()
        
        while True:
            try:
                command = input("messenger>").strip().split()
                if not command:
                    continue
                
                if command[0] == "quit":
                    break
                elif command[0] == "discover":
                    self.controller.discover_peers()
                elif command[0] == "list":
                    self.display_peers()
                elif command[0] == "msg" and len(command) >= 3:
                    mac = command[1]
                    message = " ".join(command[2:])
                    self.controller.send_text_message(mac,message)
                elif command[0] == "all" and command[1] == "msg" and len(command) >= 3:
                     mac = 'ff:ff:ff:ff:ff:ff'
                     message = " ".join(command[2:])
                     self.controller.send_text_message(mac,message)
                elif command[0] == "file" and len(command) >= 3:
                     mac , file_path = command[1] , command[2]
                     self.controller.send_file(mac,file_path)
                else:
                    print("Comando invalido")
            except KeyboardInterrupt:
                break
        self.controller.shutdown()

    def display_menu(self):
            print("Comandos disponibles:")
            print("discover - Buscar dispositivos en la red")
            print("list - Listar dispositivos encontrados")
            print("msg <mac><mensaje> - Enviar mensaje")
            print("all msg <mensaje> - Enviar mensaje a todos los dispositivos")
            print("file <mac><ruta>")
            print("quit - salir")
            print()
        
    def display_peers(self):
            peers = self.controller.discovered_peers()
            if not peers:
                 print("No hay dispositivos encontrados")
                 return
            
            print("Dispositivos encontrados")
            for mac , last_seen in peers.items():
                 print(f"{mac} (ultimo visto : {last_seen})")
        
    def display_message(self,src_mac,message):
            print(f"Mensaje de {src_mac} : {message}")
            print("messenger>",end="",flush=True)