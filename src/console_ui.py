from app_controller import AppController


class ConsoleUI:
    def __init__(self):
        self.controller = AppController(self)

    def start(self):
        print("LINK CHAT")
        interface = self.display_interfaces()
        if not self.controller.start_application(interface):
            return
        print(f"MAC Address:{self.controller.get_mac_address()}")
        self.display_menu()

        while True:
            try:
                command = input("messenger>").strip().split()
                if not command:
                    continue
                elif command[0] == "quit":
                    break
                elif command[0] == "discover":
                    self.controller.discover_peers()
                elif command[0] == "list":
                    self.display_peers()
                elif command[0] == "msg" and len(command) >= 3:
                    mac = command[1]
                    message = " ".join(command[2:])
                    self.controller.send_text_message(mac, message)
                elif command[0] == "file" and len(command) >= 3:
                    mac, file_path = command[1], command[2]
                    self.controller.send_file(mac, file_path)
                else:
                    print("Comando invalido")
            except KeyboardInterrupt:
                break
        self.controller.shutdown()

    def display_interfaces(self):
        interfaces = self.controller.list_interfaces()
        if not interfaces:
            print("No se detectaron interfaces de red.")
            return

        print("\nInterfaces de red detectadas:")
        for i, (iface, mac) in enumerate(interfaces, start=1):
            print(f"  [{i}] {iface:<20}  MAC: {mac}")

        while True:
            try:
                choice = int(input("\nSeleccione el número de la interfaz deseada: "))
                if 1 <= choice <= len(interfaces):
                    selected_iface, selected_mac = interfaces[choice - 1]
                    print(f"Interfaz seleccionada: {selected_iface} ({selected_mac})")
                    return selected_iface
                else:
                    print("Opción fuera de rango. Intenta de nuevo.")
            except ValueError:
                print("Ingresa un número válido.")

    def display_menu(self):
        print("Comandos disponibles:")
        print("discover - Buscar dispositivos en la red")
        print("list - Listar dispositivos encontrados")
        print("msg <mac><mensaje> - Enviar mensaje")
        print("file <mac><ruta>")
        print("quit - salir")
        print()

    def display_peers(self):
        peers = self.controller.discovered_peers()
        if not peers:
            print("No hay dispositivos encontrados")
            return

        print("Dispositivos encontrados")
        for mac, last_seen in peers.items():
            print(f"{mac} (ultimo visto : {last_seen})")

    def display_message(self, src_mac, message):
        print(f"Mensaje de {src_mac} : {message}")
        print("messenger>", end="", flush=True)
