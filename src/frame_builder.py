import struct


class FrameBuilder:
    @staticmethod
    def build_ethernet_frame(dest_mac, src_mac, eth_type, payload):
        # Crea frame Ethernet
        dest_bytes = bytes.fromhex(dest_mac.replace(":", ""))
        src_bytes = bytes.fromhex(src_mac.replace(":", ""))
        eth_type_bytes = struct.pack("!H", eth_type)

        # Frame completo
        frame = dest_bytes + src_bytes + eth_type_bytes + payload
        return frame

    @staticmethod
    def parse_ethernet_frame(frame):
        # Parsear frame
        if len(frame) < 14:
            return None

        dest_mac = ":".join(f"{b:02x}" for b in frame[0:6])
        src_mac = ":".join(f"{b:02x}" for b in frame[6:12])
        eth_type = struct.unpack("!H", frame[12:14])[0]
        payload = frame[14:]

        return {
            "dest_mac": dest_mac,
            "src_mac": src_mac,
            "eth_type": eth_type,
            "payload": payload,
        }
