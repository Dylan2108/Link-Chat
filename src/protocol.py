import struct
from enum import Enum
import zlib


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

        # Calcular checksum CRC32
        checksum = zlib.crc32(data_bytes)
        checksum_bytes = struct.pack("!I", checksum)
        return msg_type + length + data_bytes + checksum_bytes

    @staticmethod
    def parse_message(payload):
        # Parsear mensaje
        # Header: 1 (type) + 2 (length) = 3 bytes. Checksum: 4 bytes.
        if len(payload) < 7:
            return None

        mesg_type = payload[0]
        length = struct.unpack("!H", payload[1:3])[0]

        # Total length: 3 (header) + data length + 4 (checksum)
        if len(payload) < 3 + length + 4:
            return None

        data = payload[3 : 3 + length]
        received_checksum = struct.unpack("!I", payload[3 + length : 7 + length])[0]

        # Calcular y verificar checksum
        calculated_checksum = zlib.crc32(data)

        if received_checksum != calculated_checksum:
            print("Checksum incorrecto")
            return None

        return {"type": MessageType(mesg_type), "data": data, "length": length}
