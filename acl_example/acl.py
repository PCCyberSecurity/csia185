# Simple Access Control List (ACL)
ACL = {
    "alice": ["read", "write"],
    "bob": ["read"],
    "charlie": []
}

def check_access(user, permission):
    """Check if a user has a specific permission."""
    return permission in ACL.get(user, [])

def show_user_access(user):
    print(f"\nChecking access for user: {user}")

    if check_access(user, "read"):
        print("  ✔ Read access granted")
    else:
        print("  ✘ Read access denied")

    if check_access(user, "write"):
        print("  ✔ Write access granted")
    else:
        print("  ✘ Write access denied")


# Demonstrate ACL usage
users_to_test = ["alice", "bob", "charlie", "dave"]

for user in users_to_test:
    show_user_access(user)
