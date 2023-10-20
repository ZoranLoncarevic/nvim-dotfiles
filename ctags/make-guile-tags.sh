#!/usr/bin/bash

find /usr/share/guile/2.2/ -regex '.*[.]scm' | ctags -L - -f ./guile
