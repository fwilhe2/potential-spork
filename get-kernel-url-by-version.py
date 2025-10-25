from urllib.request import urlopen
import json
import argparse

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("kernel_version", help="Kernel version (major.minor)", type=str)
    parser.add_argument("item", help="version or source", type=str)
    args = parser.parse_args()


    with urlopen('https://www.kernel.org/releases.json') as response:
        releases = json.loads(response.read().decode())['releases']
        for r in releases:
            if r['version'].startswith(args.kernel_version):
                print(r[args.item])