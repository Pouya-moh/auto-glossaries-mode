# auto-glossaries-mode

This is small minor mode to facilitates the use of glossaries package
workflow. It automatically surrounds entries of an acronym file with
`gls{foo}`.

## TODO
1. Find a way to easily suppress it without disabling the minor mode
2. Automatically update the acronym list when external file is saved
3. Make it more general so that it will be able to handle different macros from similar packages
4. Add some sanity test
5. Do some benchmarking since currently it looks a bit slow (maybe just *feels* slow)
