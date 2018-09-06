untrack-generated-init:
	git update-index --assume-unchanged init.el

track-init:
	git update-index --no-assume-unchanged init.el
