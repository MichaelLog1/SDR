import numpy as np
import socket

def recv_all(sock, target_length):
    buffer = b""
    while len(buffer) < target_length:
        chunk = sock.recv(target_length - len(buffer))
        if not chunk:
            raise ConnectionError("Socket closed before receiving full message")
        buffer += chunk
    return buffer

def main():
    socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.connect(('169.254.197.70', 1234))   # the BOARD's IP + port
    print("connected...") 

    frame = recv_all(sock, 4096)

    w = np.frombuffer(frame, dtype='<u4')
    I = w.astype(np.int32) >> 16
    Q = (w & 0xFFFF).astype(np.int16)
    I = I.astype(np.int16)
    iq = I.astype(np.float32) + 1j * Q.astype(np.float32)

    spec = np.fft.fftshift(np.fft.fft(iq))
    psd  = 20*np.log10(np.abs(spec) + 1e-9)
    freqs = np.fft.fftshift(np.fft.fftfreq(1024, d=1/49152.0))

    peak = np.argmax(psd)
    print(f"peak: {freqs[peak]:8.0f} Hz   {psd[peak]:6.1f} dB")
    


if __name__ == "__main__":
    main()
