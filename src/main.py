from app_controller import AppController

def main():
    interface = input("Ingrese la interfaz de red a usar ").strip()

    if not interface:
        print("Se debe especificar una interfaz valida")
        return 1
    
    app = AppController(interface)

    success = app.start_application()

    return 0 if success else 1

if __name__ == "__main__":
    exit(main())