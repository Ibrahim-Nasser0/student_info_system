import time

def measure(func):
    def wrapper(*args, **kwargs):
        start = time.time()
        result = func(*args, **kwargs)
        print(f"Time taken: {time.time() - start:.5f} sec")
        return result
    return wrapper
