import time
import string
import itertools
import sys

# Character set: digits + lowercase + uppercase + symbols
charset = string.digits + string.ascii_lowercase + string.ascii_uppercase + string.punctuation

max_length = 8
update_interval = 10_000_000  # update every N attempts

# Calculate total combinations
total = sum(len(charset) ** length for length in range(1, max_length + 1))

print(f"Total combinations to attempt: {total:,}")

start_time = time.perf_counter()
count = 0

for length in range(1, max_length + 1):
    for _ in itertools.product(charset, repeat=length):
        count += 1

        if count % update_interval == 0:
            elapsed = time.perf_counter() - start_time
            percent = (count / total) * 100
            attempts_per_sec = count / elapsed if elapsed > 0 else 0
            eta = (total - count) / attempts_per_sec if attempts_per_sec > 0 else float('inf')

            sys.stdout.write(
                f"\r{percent:012.10f}% | "
                f"{count:,} attempts | "
                f"{attempts_per_sec:,.0f} attempts/sec | "
                f"ETA: {eta/3600:,.2f} hrs"
            )
            sys.stdout.flush()

end_time = time.perf_counter()

print("\n\nFinished.")
print(f"Total attempts: {count:,}")
print(f"Total time: {end_time - start_time:.2f} seconds")