from brownie import Collectible

def main():
    flatten()

def flatten():
    file = open("./Collectible_flattened.sol","w")
    verification_information = Collectible.get_verification_info()
    flattened_code = (
        verification_information["flattened_source"]
        .replace("\\n", "\n")
        .replace('\\"', '"')
    )   
    file.write(flattened_code)
    file.close()