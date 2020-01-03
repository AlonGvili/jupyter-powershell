# Docker Image for jupyter-powershell

Dockerized PowerShell language kernel for Jupyter. Works on Linux and Docker Desktop.

## Build Container Image

To build the container image, run the following command:

```
docker build --tag jupyter-powershell .
```

To run a container, run the following command:

```
docker run --interactive --tty --publish 8080:8080 jupyter-powershell
```

## Acknowledgement

This is an early prototype, but I tried to avoid unnessesary dependencies.

This kernel is heavily based on https://github.com/takluyver/bash_kernel (as jupyter kernel example) and 
https://github.com/wuub/SublimeREPL for calling PowerShell repl from python.

`bash_kernel` has BSD 3-clause license.
`SublimeREPL` has complicated license, so here is a careful explanation of the used parts.

From https://github.com/wuub/SublimeREPL/blob/94e859eae3b9a665a818ff7e13e45edf303ef87b/LICENSE-LIB.txt

```
This means that, although the parts of SublimeREPL that I (wuub) wrote are published under BSD license and you're free to reuse them as you wish, the whole SublimeREPL package is as of now licensed under GPLv2.
```

I'd like to avoid GPLv2 dependencies (and I don't need any of that code), so I want to list all used code (BSD/MIT):

* `subprocess_repl.py` wrote by wuub, licensed under BSD/MIT.
