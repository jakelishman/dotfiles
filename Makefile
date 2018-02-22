packages=bash ssh git vim python

install:
	stow --no-folding ${packages} -t ${HOME}

uninstall:
	stow -D ${packages} -t ${HOME}
