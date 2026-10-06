import socket, os, glob

def reload_mango():
    runtime_dir = os.environ.get("XDG_RUNTIME_DIR", "/run/user/1000")
    sockets = glob.glob(os.path.join(runtime_dir, "mango-*.sock"))
    if not sockets:
        return
    for sock_path in sockets:
        try:
            s = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
            s.connect(sock_path)
            s.sendall(b"dispatch reload_config\n")
            s.close()
        except:
            pass

if __name__ == "__main__":
    reload_mango()
