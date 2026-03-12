import time
import string
import itertools

charset = string.digits + string.ascii_lowercase  # smaller set

start_time = time.perf_counter()

count = 0
for password in itertools.product(charset, repeat=4):  # only 4 characters
    count += 1

end_time = time.perf_counter()

print(f"Combinations: {count}")
print(f"Time taken: {end_time - start_time:.6f} seconds")