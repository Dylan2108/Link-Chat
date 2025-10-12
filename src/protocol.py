import struct
from enum import Enum


class MessageType(Enum):
    Discovery = 0x01
    Discovery_Response = 0x02
    Message = 0x03
    File_Request = 0x04
    File_Chunk = 0x05
    File_Complete = 0x06
    ACK = 0x07


class Protocol:
    ETH_TYPE = 0x88B5

    @staticmethod
    def create_message(message_type, data):
        # Crea payload del protocolo
        msg_type = struct.pack("B", message_type.value)
        data_bytes = data.encode("utf-8") if isinstance(data, str) else data
        length = struct.pack("!H", len(data_bytes))

        # Calcular checksum simple
        checksum = sum(data_bytes) % 65536
        checksum_bytes = struct.pack("!H", checksum)
        return msg_type + length + data_bytes + checksum_bytes

    @staticmethod
    def parse_message(payload):
        # Parsear mensaje
        if len(payload) < 5:
            return None

        mesg_type = payload[0]
        length = struct.unpack("!H", payload[1:3])[0]

        if len(payload) < 3 + length + 2:
            return None

        data = payload[3 : 3 + length]
        received_checksum = struct.unpack("!H", payload[3 + length : 5 + length])[0]
        calculated_checksum = sum(data) % 65536

        if received_checksum != calculated_checksum:
            print("Checksum incorrecto")
            return None

        return {"type": MessageType(mesg_type), "data": data, "length": length}
