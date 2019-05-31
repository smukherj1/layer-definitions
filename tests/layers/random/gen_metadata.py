import yaml
import random
import time
import sys

if __name__ == "__main__":
    result = {
        "tags": ["test"],
        "packages" : [],
    }
    random.seed(time.time())
    for i in range(10):
        result["packages"].append(random.randint(1, 100))
    with open(sys.argv[1], "w") as ofp:
        yaml.dump(result, stream=ofp)
