import socket
import threading

# change this addr according to the network you are using
ip = '127.0.0.1'
# adjust this bcast addr for communication
bcast_addr = '127.0.0.255'
# por using for listening incomming messages
port = 5000

name = input("Please provide your nickname: ")

def listen_for_messsages():
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    # why does we use 0.0.0.0 ? 
    sock.bind(('0.0.0.0', port))

    while True:
        data, client_address = sock.recvfrom(4096)
        message = data.decode().split(":")
        nick = message[0][:-1]

        print(f"Received message from {nick} using {client_address}: {message[1]}\n")

def main_thread():

    while True:
        with socket.socket(socket.AF_INET, socket.SOCK_DGRAM) as sock:
            sock.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)
            message = input(f"Introduzca el mensaje a enviar: ")
            message_with_nick = f"{name}: {message}"
            sock.sendto(message_with_nick.encode(), (bcast_addr, port))

t = threading.Thread(target=listen_for_messsages)
t.start()

main_thread()
t.join()


# two possible improvements:
# 1. Avoid recieving messages from your own
# 2. Try to improve the output of the incomming messages, ex, avoid to ovewrite the input message