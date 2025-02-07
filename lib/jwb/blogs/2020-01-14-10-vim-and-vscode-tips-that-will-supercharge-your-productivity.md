---
slug: 10-vim-tips
title: 10 Vim + VSCode tips that will supercharge your productivity
description: How I develop faster with these quick Vim + VSCode tips
tags: ["productivity", "vim"]
---
![vim easymotion](https://media.giphy.com/media/WsXAdBLva8z4soCNg9/giphy.gif)

When I started [Flowist.io](https://flowist.io), I decided: **I want to learn vim. And I want to be fast.**

Learning Vim can be hard at first. But combining it with VSCode can make that a bit easier - and you get the best of both worlds!

Here are some of the most useful tips and tricks that instantly allowed me to work faster! *P.S.: great resource for starting out: [devhints.io/vim](https://devhints.io/vim)*

>**Vim secret:** It's not hard. Just learn what the letters mean, combine them, and see what happens!

## Setup
First of all, to install vim in vscode:

    1. Open Visual Studio Code
    2. Go to Extensions
    3. Search for vim
    4. The first plugin named Vim is the one you want
    5. Click install
    6. Boom!


##1. vim-surround

This plugin lets you surround with or remove surrounding elements (think: `"`, `'`, `{}`, `()`, etc.)

This is a must-have plugin for Vim. I don't believe in immediately installing tons of plugins, but some of them are just necessary.

`ve S<tag>`
![vim-surround](https://media.giphy.com/media/MaaI2xC7bDA9oqAUKx/giphy.gif)

##2. vim-motion

Press the keybind and then use the letters to move through your file. Another must-have. Not a replacement for other Vim movements, but incredibly useful for moving quickly and being more productive.

My keybind and config to jump-start you :)

```json
    "vim.easymotionMarkerFontFamily": "FiraCode-Retina",
    "vim.easymotionMarkerBackgroundColor": "#7e57c2",
    "vim.easymotionMarkerWidthPerChar": 8,
    "vim.easymotionMarkerFontSize": "14",
    "vim.easymotionMarkerYOffset": 4,
    "vim.normalModeKeyBindingsNonRecursive": [
        {
            "before": [" "],
            "after": ["leader", "leader", "leader", "b", "d", "w"],
        }
    ],
    "vim.easymotion": true,
    "vim.hlsearch": true,
```

`> <space>`
![vim-motion](https://media.giphy.com/media/mFHYnFaAh4EsK6mOp8/giphy.gif)

##3. jj

Hitting `<esc>` sucks. I didn't realize I wasn't the only one who felt this, and everyone knew a better way. Map something simple to `<esc>` instead (I use `jj`, but anything easy works.)

```jj
    "vim.insertModeKeyBindings": [
        {
            "before": ["j", "j"],
            "after": ["<esc>"]
        }
    ]
```

`> jj`
![jj](https://media.giphy.com/media/VhjC1QG5QBuVJmoUJF/giphy.gif)


##4. cmd + p

Open files super quickly. Don't use the mouse!

`> cmd+p`
![cmd+p](https://media.giphy.com/media/IhDnmZwZRtZ9VNOtYR/giphy.gif)

##5. V

Visual mode (think highlight and select) but for a *whole line* at a time. 
Didn't know this existed either. 

`> V`
![V](https://media.giphy.com/media/f6hc3ifyZl3YeVDwB5/giphy.gif)

##6. yip, yap

Here's where things get expressive!

Helpful for grabbing functions or methods and quickly copying them to paste elsewhere.


>**y** = yank
>**i** = inner (in)
>**p** = paragraph

and

>**y** = yank
>**a** = a
>**p** = paragraph (including newlines)

`> yap`
![yap](https://media.giphy.com/media/fw8yroCvHwb0A6AFkE/giphy.gif)

##7. cit, yit

Great for editing HTML. 10x faster then navigating inside of the tag and editing or copying it.


>**c** = change
>**i** = inner (in)
>**t** = tag (**YES, html tags!**)

**Bonus tip:** Use ", and { to speed up html and javascript editing too!
and

>**y** = yank
>**i** = inner (in)
>**t** = tag

`> cit`
![change in tag](https://media.giphy.com/media/VfDvTq4lIcH1kKd6K0/giphy.gif)

##8. dw, df<space>

Easily remove words faster.


>**d** = delete
>**w** = word

and

>**d** = delete
>**f** = find
>**<space>** = item to search for and include in the delete

`> dw dfs`
![delete](https://media.giphy.com/media/J6CerVKapxpzPAZW6v/giphy.gif)

##9. ci", ci{

Change class tags, hrefs, strings and edit function bodies way faster.


>**c** = change
>**i** = inner (in)
>**"** = item to change inside of

and

>**c** = change
>**i** = inner (in)
>**{** = item to change inside of

`> ci{`
![change in {](https://media.giphy.com/media/Wov6oiizGBRtQajSAH/giphy.gif)

##10. f_, F_

Super useful for moving to specific items. Way faster than `lllllll` or even `8l`...`h`


>**f** = find (ahead of cursor)
>**_** = anything to search for

and

>**F** = Find (behind cursor)
>**_** = anything to search for

`> f2 F3`
![find](https://media.giphy.com/media/ZD7x5gjbgLDESwr4nz/giphy.gif)

##BONUS: u, r

Some bonus must-haves!


>**u** = undo the last change

and

>**r** = replace (r + thing to replace with)

`> <space> dit ... u`
![undo](https://media.giphy.com/media/WsXAdBLva8z4soCNg9/giphy.gif)


## Conclusion

Since I started working on [Flowist.io](https://flowist.io) I made a serious effort to get proficient with vim. Hopefully, this helps you boost your vim speed too!

Thanks for reading :) Catch me on twitter [@jwbaldwin_](https://twitter.com/jwbaldwin_)
