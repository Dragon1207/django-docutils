WATCH_FILES= find . -type f -not -path '*/\.*' | grep -i '.*[.]py$$' 2> /dev/null
PY_FILES= ${WATCH_FILES}
SHELL := /bin/bash

test:
	poetry run py.test $(test)

entr_warn:
	@echo "----------------------------------------------------------"
	@echo "     ! File watching functionality non-operational !      "
	@echo ""
	@echo "Install entr(1) to automatically run tasks on file change."
	@echo "See http://entrproject.org/"
	@echo "----------------------------------------------------------"


watch_test:
	if command -v entr > /dev/null; then ${WATCH_FILES} | entr -c $(MAKE) test; else $(MAKE) test entr_warn; fi

build_docs:
	pushd docs; $(MAKE) html; popd

watch_docs:
	pushd docs; $(MAKE) watch_docs; popd

black:
	poetry black `${PY_FILES}`

isort:
	poetry isort `${PY_FILES}`

flake8:
	poetry flake8 django_docutils tests

watch_flake8:
	if command -v entr > /dev/null; then ${WATCH_FILES} | entr -c $(MAKE) flake8; else $(MAKE) flake8 entr_warn; fi

clean:
	rm -rf *.egg-info dist build
