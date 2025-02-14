---
slug: rebuilding-my-personal-site-with-phoenix-liveview
title: Rebuilding my personal site with Phoenix LiveView
description: Some interesting details on my new personal website
tags: ["elixir", "phoenix", "phoenix-liveview"]
---

## The why

My last personal website was built with Nuxt.js. I'd been using Vue for my side projects at the time
and it had an plug-n-play CMS (and had some nice templates). Howver, I wasn't really happy with it: it didn't feel
like mine. I wanted a personal site that I could play around with and try new things on. The language I do those
things in is Elixir, so I decided to rebuild it with Phoenix LiveView.

## The how

All credit goes to [@dashbit](https://twitter.com/dashbit) for the original implementation of the blog portion of this site.

You can find their break down (which is excellent) at https://dashbit.co/blog/welcome-to-our-blog-how-it-was-made

I wanted to talk a little bit about the process of rebuilding it, and how I went about it.

I moved my blogs over from my old site into a directory called `lib/jwb/blogs` (and projects went to `lib/jwb/projects`).

I'd already had the blog posts named with the date, like `2019-12-08-solving-fizzbuzz-with-elixir.md`. So parsing out the date
was nice and easy:

```elixir
[year, month, day, slug_with_md] = String.split(filename, "-", parts: 4)
date = Date.from_iso8601!("#{year}-#{month}-#{day}")
```

And then I just needed to create and partse the metadata from the rest of the file.

A blog post metadata looks like this:

```markdown
---
slug: rebuilding-my-personal-site-with-phoenix-liveview
title: Rebuilding my personal site with Phoenix LiveView
description: Some interesting details on my new personal website
tags: ["elixir", "phoenix", "phoenix-liveview"]
---
```

The `slug` is the unique identifier for the post, and is used to generate the URL.

A project metadata looks like this:

```markdown
---
category: SaaS App
name: Kept
description: A customer engagement and insight platform for retailers
cover: /images/kept-logo.png
gallery: ["/images/kept-home.jpg"]
---
```

The parser really only differs a bit from Dashbit's parser, the key different is the start and end delimiters that mean I do something like:
```elixir
[frontmatter, body] = String.split(contents, "\n---\n", parts: 2)
details = String.trim_leading(frontmatter, "---\n")
# Parse details into key-value pairs, etc.
```

Rendering these out is really straight forward then since I can just turn these into structs, and grab the `%Post{}` body. And I can just render the images in the gallery metadata directly!

### Using AI the build a highlighter

One of the things I wanted to do was to use my favorite theme to highlight code blocks. But `makeup_elixir` doesn't
have a `tokyonight` theme. 

So I ran `Makeup.stylesheet()` and got the CSS for the default theme, then
I grabbed the color values from tokyonight and asked Claude to use it's knowledge of the Tokyonight theme, the provided colors, 
and the provided stylesheet to create a new stylesheet.

Et voila! I have tokyonight syntax highlighting! It's not perfect, but it's pretty close and I can tweak it to my liking.


### What's next

I'm really happy with the result. It feels a lot more like me, and I feel far more excited to continue to extend it
in unqiue ways and polish it until I'm proud of it.
