#!/usr/bin/env python


from itertools import imap


def read_requirements(filename):
    import string
    with open(filename) as f:
        return map(string.strip, f)


def install(requirement):
    """
    Returns
    -------
    successfully_installed :: boolean
    """
    print(
        "Installing '{}'".format(requirement)
    )
    import os

    return not(
        os.system(
            "pip install {requirement}".format(
                requirement=requirement,
            )
        )
    )


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
