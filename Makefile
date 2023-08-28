-include .env

DEFAULT_ANVIL_KEY := 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

# Foundry Helpers

format:; forge fmt
clean:; forge clean
compile:; forge compile
build:; forge build
test:; forge test
snapshot:; forge snapshot

anvil :; anvil -m 'test test test test test test test test test test test junk' --steps-tracing --block-time 1

NETWORK_ARGS := --rpc-url http://localhost:8545 --private-key $(DEFAULT_ANVIL_KEY) --broadcast

ifeq ($(findstring --network sepolia,$(ARGS)),--network sepolia)
	NETWORK_ARGS := --rpc-url $(SEPOLIA_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv
endif

deploy:
	@forge script ./script/DeployBattleship.s.sol:DeployBattleship ${NETWORK_ARGS}

newGame:; cast send --gas-limit 100000 0x5fbdb2315678afecb367f032d93f642f64180aa3 "createGame(uint8,string,string)" 10 "Alice" "Bob" --private-key $(DEFAULT_ANVIL_KEY)
