# export NODE_OPTIONS=--openssl-legacy-provider
from scripts.helpfull_scripts import get_account, get_contract, fund_with_link, OPENSEA_URL
from brownie import Collectible, config, network

def deploy_and_create():
    account = get_account()
    collectible = Collectible.deploy(
        get_contract("vrf_coordinator"),
        get_contract("link_token"),
        config["networks"][network.show_active()]["keyhash"],
        config["networks"][network.show_active()]["fee"],
        {"from":account}
    )
    fund_with_link(collectible.address)
    creating_tx = collectible.createCollectible({"from":account})
    creating_tx.wait(1)
    print("New token has been created")
    return collectible, creating_tx


def main():
    deploy_and_create()