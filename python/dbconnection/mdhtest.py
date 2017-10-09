import hashlib
N = 'admin'
print(hashlib.md5(str(N).encode("utf-8")).hexdigest())