import time
import string
import itertools
import hashlib

charset = string.digits + string.ascii_lowercase  # smaller set

start_time = time.perf_counter()

count = 0
for password_tuple in itertools.product(charset, repeat=4):  # only 4 characters
    password = ''.join(password_tuple)
    
    # SHA1 hash calculation
    sha1_hash = hashlib.sha1(password.encode()).hexdigest()
    
    count += 1

end_time = time.perf_counter()

print(f"Combinations: {count}")
print(f"Time taken: {end_time - start_time:.6f} seconds")