#!/usr/bin/env python3

import os
import logging

from pathlib import Path  # python3 only
from dotenv import load_dotenv

env_path = Path('.') / 'env.sh'
load_dotenv(dotenv_path=env_path)

logging.basicConfig(level=logging.DEBUG)


class Config:
    def __init__(self):
        """
        host = VPN_HOST
        port = 443
        username = VPN_USER
        password = VPN_PASS

        trusted-cert = VPN_TRUSTED_CERT

        insecure-ssl = true
        #realm =
        set-dns = true
        set-routes = true
        """

        self.CONFIG = os.getenv('CONFIG')

        self.SSH_USER = os.getenv('SSH_USER')
        self.SSH_USER_PASS = os.getenv('SSH_USER_PASS')

        self.VPN_USER = os.getenv('VPN_USER')
        self.VPN_PASS = os.getenv('VPN_PASS')
        self.VPN_HOST = os.getenv('VPN_HOST')
        self.VPN_TRUSTED_CERT = os.getenv('VPN_TRUSTED_CERT')

        self.config = ''
        self.config += 'host = {}\n'.format(self.VPN_HOST)
        self.config += 'port = 443\n'
        self.config += 'username = {}\n'.format(self.VPN_USER)
        self.config += 'password = {}\n'.format(self.VPN_PASS)
        self.config += '\n'
        self.config += 'trusted-cert = {}\n'.format(self.VPN_TRUSTED_CERT)
        self.config += '\n'
        self.config += 'insecure-ssl = true\n'
        self.config += '#realm =\n'
        self.config += 'set-dns = true\n'
        self.config += 'set-routes = true\n'

    def show(self):
        print(self.config)

    def save(self, file=None):
        if not file:
            file = self.CONFIG

        with open(file, 'w') as f:
            f.write(self.config)
            logging.info('Config saved')


if __name__ == "__main__":
    Config().save()
