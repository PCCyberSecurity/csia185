import random
import time

# Set the seed for reproducibility
random.seed(time.ctime())

for i in range(5):
    # Generate a random number (example: an integer between 1 and 100)
    random_number = random.randint(1, 100)

    print(random_number)


