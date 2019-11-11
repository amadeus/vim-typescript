# vim-typescript

TypeScript bundle for vim, this bundle provides syntax highlighting and
improved indentation.  It has been forked from
[pangloss/vim-javascript](https://github.com/pangloss/vim-javascript)


## Installation

Use your favorite plugin manager.


## Configuration Variables

The following variables control certain syntax highlighting plugins. You can
add them to your `.vimrc` to enable their features.

-----------------

```
let g:typescript_plugin_jsdoc = 1
```

Enables syntax highlighting for [JSDocs](http://usejsdoc.org/).

Default Value: 0

-----------------

```
let g:typescript_plugin_ngdoc = 1
```

Enables some additional syntax highlighting for NGDocs. Requires JSDoc plugin
to be enabled as well.

Default Value: 0

-----------------

```vim
augroup typescript_folding
    au!
    au FileType typescript setlocal foldmethod=syntax
augroup END
```

Enables code folding for typescript based on our syntax file.

Please note this can have a dramatic effect on performance.

## Indentation Specific

* `:h cino-:`
* `:h cino-=`
* `:h cino-star`
* `:h cino-(`
* `:h cino-w`
* `:h cino-W`
* `:h cino-U`
* `:h cino-m`
* `:h cino-M`
* `:h 'indentkeys'`

## License

Distributed under the same terms as Vim itself. See `:help license`.
