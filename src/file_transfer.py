import os
import struct
import time
from protocol import MessageType

class FileTransferManager:
    def __init__(self,network_manager):
        self.network = network_manager
        self.file_chunks = {}
        self.chunk_size = 1024
    
    def send_file(self,dest_mac,file_path):
        if not os.path.exists(file_path):
            print(f"Archivo {file_path} no encontrado")
            return False
        
        file_name = os.path.basename(file_path)
        file_size = os.path.getsize(file_path)
        file_info = f"{file_name}:{file_size}"

        if not self.network.send_message(dest_mac,MessageType.File_Request,file_info):
            return False
        
        with open(file_path,"rb") as f:
            chunk_id = 0
            while True:
                chunk = f.read(self.chunk_size)
                if not chunk:
                    break

                chunk_header = struct.pack('!H',chunk_id) + chunk
                if not self.network.send_message(dest_mac,MessageType.File_Chunk,chunk_header):
                    print(f"Error enviando chunk {chunk_id}")
                    return False
                
                chunk_id += 1
                time.sleep(0.01)

            self.network.send_message(dest_mac,MessageType.File_Complete,file_name)
            print(f"Archivo {file_name} enviado correctamente")
            return True
        
    def handle_file_chunk(self,src_mac,data):
            if len(data) < 2:
                return
            
            chunk_id = struct.unpack('!H',data[0:2])[0]
            chunk_data = data[2:]

            if src_mac not in self.file_chunks:
                self.file_chunks[src_mac] = {}
            
            self.file_chunks[src_mac][chunk_id] = chunk_data
            print(f"Recibido chunk {chunk_id}  de {src_mac}")
    def handle_file_complete(self,src_mac,filename_data):
        filename = filename_data.decode('utf-8')
        if src_mac not in self.file_chunks:
            return False
        
        chunks = self.file_chunks[src_mac]
        sorted_chunks = [chunks[i] for i in sorted(chunks.keys())]

        with open(f"received_{filename}",'wb') as f:
            for chunk in sorted_chunks:
                f.write(chunk)
        
        print(f"Archivo {filename} recibido correctamente")
        del self.file_chunks[src_mac]
        return True