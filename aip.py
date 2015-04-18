#!/usr/bin/env python


from itertools import imap
from operator import methodcaller


def read_requirements(filename):
    import string
    def not_(f):
        return lambda *args, **kwargs: not(f(*args, **kwargs))

    with open(filename) as f:
        return filter(
            not_(methodcaller('startswith', '#')),
            map(string.strip, f)
        )


def install(requirement):
    """
    Returns
    -------
    successfully_installed :: boolean
    """
    package, version = requirement.split('==')
    print(
        "Installing '{}'".format(requirement)
    )
    import subprocess

    command = "pip install --allow-external {package} --allow-unverified {package} {package}=={version}".format(
        package=package,
        version=version,
    )
    print("command: {}".format(command))

    try:
        subprocess.check_call(
            command,
            shell=True,
        )
        return True

    except subprocess.CalledProcessError as cpe:
        return False


def main(args):
    assert(args.subcommand == "install")
    import sys
    requirements = read_requirements(args.requirements_file)

    def install_round(i):
        print(
            "Installation round #{}".format(
                i
            )
        )

        return all(
            map(
                install,
                requirements
            )
        )

    sys.exit(
        not(
            any(
                imap(
                    install_round,
                    range(len(requirements))
                )
            )
        )
    )


if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(
        description=(
            "Installs python packages by trying "
            "to reinstall them until everything passes"
        )
    )

    parser.add_argument(
        "subcommand",
        type=str,
    )
    parser.add_argument(
        "-r",
        "--requirement",
        dest="requirements_file",
        type=str,
    )
    args = parser.parse_args()

    main(args)
