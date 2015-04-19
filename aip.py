#!/usr/bin/env python
from __future__ import division, print_function

from itertools import imap, ifilterfalse
from operator import methodcaller

import sh
from sh import ErrorReturnCode


def read_requirements(filename):
    import string

    def not_(f):
        def not_f(*args, **kwargs):
            return not(f(*args, **kwargs))

        return not_f

    with open(filename) as f:
        return filter(
            not_(methodcaller('startswith', '#')),
            map(string.strip, f)
        )


def pip(package, version):
    try:
        sh.pip.install(
            "{}=={}".format(package, version),
            allow_external=package,
            allow_unverified=package,
        )

        return True

    except ErrorReturnCode:
        return False


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

    return pip(package, version)


def main(args):
    assert(args.subcommand == "install")

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

    import sys
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


def main_fast(args):
    assert(args.subcommand == "install")

    requirements = read_requirements(args.requirements_file)

    def installs(requirements):
        print("Installs:")
        map(
            print,
            map(
                "- {}".format,
                requirements
            )
        )

        def install(requirement):
            package, version = requirement.split('==')

            print(
                "Installing '{}:{}'".format(
                    package,
                    version,
                )
            )

            pip_success = pip(package, version)

            return pip_success

        failed_requirements = list(ifilterfalse(
            install,
            requirements
        ))

        installs(failed_requirements)

    installs(requirements)

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

    main_fast(args)
