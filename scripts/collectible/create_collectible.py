from brownie import Collectible
from scripts.helpfull_scripts import fund_with_link, get_account
from web3 import Web3

def main():
    account = get_account()
    collectible = Collectible[-1]
    fund_with_link(collectible.address, amount = Web3.toWei(0.1, "ether"))
    creation_transaction = collectible.createCollectible({"from":account})
    creation_transaction.wait(1)
    print("Collectible created")