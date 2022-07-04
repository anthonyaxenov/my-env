## droidcam: Install droidcam
droidcam:
	./install/droidcam.sh

## droidcam-obs: Install droidcam-obs plugin
droidcam-obs:
	./install/droidcam-obs.sh

#---------------------------------------------------

## help: This message
help: Makefile
	@echo "Choose a command run:"
	@sed -n 's/^##//p' $< | column -t -s ':' |  sed -e "s/^/\t/"
