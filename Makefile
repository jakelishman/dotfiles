packages=bash ssh git vim python

install:
	stow --no-folding ${packages} -t ${HOME}

uninstall:
	stow --no-folding -D ${packages} -t ${HOME}
