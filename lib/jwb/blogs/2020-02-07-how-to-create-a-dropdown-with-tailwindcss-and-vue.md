---
slug: create-a-dropdown-with-tailwindcss
title: How to create a dropdown with TailwindCSS and Vue
description: Create custom dropdowns with TailwindCSS and Vue by example (and codesandbox)
tags: ["vue", "tailwindcss", "tutorial"]
---
I'm going to assume you already have Vue and TailwindCSS set up, but if you don't here is a great resource: [github.com/tailwindcss/setup-examples](https://github.com/tailwindcss/setup-examples/tree/master/examples/vue-cli)

Here are the versions of Vue and TailwindCSS that I'm using:

`Vue: 2.6.10`
`TailwindCSS: 1.2.0`


**All the code for this can be found on my github at [github.com/jwbaldwin](https://github.com/jwbaldwin) and in the codesandbox below!**

Alright, let's get right into it.

## First: The Setup

We'll have two main components for this. The Vue component that will act as the dropdown, and the Vue component which will open the dropdown when clicked.

The dropdown component will be pretty straight forward:
```vue
//MainDropdown.vue
<template>
    <div>
        <div>
            <div></div> <- Where our functionality will go
            <slot></slot> <- Where we will put the dropdown items
        </div>
    </div>
</template>

<script>
export default {
    data() {
        return { <- Where we will track our modal state (open/closed)
        };
    },
    methods: { <- Where we will toggle the state
    },
};
</script>
```

Okay! Nothing fancy going on here. A little [Vue slot](https://vuejs.org/v2/guide/components-slots.html) api usage, so that we can reuse this component for dropdowns all throughout the app! Basically, we're going to define what we want rendered in that *slot* in another component.

So, let's scaffold the items we'll display!
```vue
//ButtonWithDropdown.vue
<template>
  <main-dropdown>
    <template> <- Where we will say "hey vue, put this in the slot"
      <img src="../assets/profile.png" alt="profile image">
      <div> <- What we want displayed in the dropdown
        <ul>
          <li>
            <a to="/profile">
              <div>{{ username }}</div>
              <div>{{ email }}</div>
            </a>
          </li>
          <li>
            <a to="/profile">Profile</a>
          </li>
          <li>
            <a>Sign out</a>
          </li>
        </ul>
      </div>
    </template>
  </main-dropdown>
</template>

<script>
import MainDropdown from "@/components/MainDropdown";

export default {
  name: "button-with-dropdown",
  data() {
    return {
      username: "John Wick",
      email: "dontkillmydog@johnwick.com"
    };
  },
  components: { MainDropdown }
};
</script>
```

Great, so it looks terrible *and* doesn't work. Let's fix the style with TailwindCSS.

## Next: The Styling

```vue
//MainDropdown.vue
<template>
  <div class="flex justify-center">
    <div class="relative">
      <div class="fixed inset-0"></div>
      <slot></slot>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {};
  },
  methods: {}
};
</script>

```
The div element with `fixed inset-0` will **cover the entire page**. Just remember this little guy. More on what it does later!

We're going to make sure the parent is "relative" so that we can position the child dropdown absolute in relation to that element. And then we apply some other positioning so that it sits where we want it to!

```vue
//ButtonWithDropdown.vue
<template>
    <main-dropdown>
        <template>
            <img class="object-cover w-10 h-10 border-2 border-gray-400 rounded-full cursor-pointer" src="../assets/profile.png" alt="profile image">
            <transition 
             enter-active-class="transition-all duration-100 ease-out" 
             leave-active-class="transition-all duration-100 ease-in" 
             enter-class="scale-75 opacity-0"
             enter-to-class="scale-100 opacity-100"
             leave-class="scale-100 opacity-100"
             leave-to-class="scale-75 opacity-0">
                <div class="absolute right-0 w-64 mt-2 overflow-hidden origin-top-right bg-white border rounded-lg shadow-md">
                    <ul>
                        <li>
                            <a to="/profile" class="block px-4 py-3 rounded-t-lg hover:bg-gray-100">
                                <div class="font-semibold ">{{ username }}</div>
                                <div class="text-gray-700">{{ email }}</div>
                            </a>
                        </li>
                        <li class="hover:bg-gray-100">
                            <a class="block px-4 py-3 font-semibold" to="/profile">Profile</a>
                        </li>
                        <li class="hover:bg-gray-100">
                            <a class="block px-4 py-3 font-semibold" to="/profile">Sign Out</a>
                        </li>
                    </ul>
                </div>
...
</script>
```

There's a bit more going on here. Most of it is just styling, but we are adding a couple of things I want to point out. 

1. We are using the <transition> element provided by Vue and then combining that with TailwindCSS classes to make the dropdown fade in and out! (when it actually opens and closes)
2. We have some `hover:` pseudo-class variants that apply styles based on if an element is hovered or not.

Alright! It's really coming along. Not half-bad, but let's make it work!


## Finally: The Functionality

**The key interaction here:**

The `MainDropdown.vue` component, that we <slot> the button into, will allow the `ButtonWithDropdown.vue` component to access it's context and call methods provided by `MainDropdown.vue`.

Let's see how that works!

```vue
//MainDropdown.vue
<template>
    <div class="flex justify-center">
        <div class="relative">
            <div v-if="open" @click="open = false" class="fixed inset-0"></div>
            <slot :open="open" :toggleOpen="toggleOpen"></slot>
        </div>
    </div>
</template>

<script>
export default {
    data() {
        return {
            open: false,
        };
    },
    methods: {
        toggleOpen() {
            this.open = !this.open;
        },
    },
};
</script>
```

Okay so let's go over what we did here:

1. We added a boolean `open: false` to our component data. This will determine if we show the dropdown (and our "fixed inset-0" element) or not.
2. We added a `toggleOpen()` method that will simple invert the state of that `open` state.
3. We added `v-if="open" @click="open = false"` to our `fixed inset-0` element. Remember how I said this element will cover the whole page? Right, so now it only shows when our dropdown is open, so if we click anywhere outside of the dropdown...boom! The dropdown closes as you'd expect! (told ya I'd explain that, not magic anymore)
4. Finally, we pass bind `:open` and `:toggleOpen` to our <slot>

Okay, the final touches!

```vue
//ButtonWithDropdown.vue
<template>
    <main-dropdown>
        <template slot-scope="context">
            <img @click="context.toggleOpen" class="object-cover w-10 h-10 border-2 border-gray-400 rounded-full cursor-pointer" src="../assets/profile.png" alt="profile image">
            <transition enter-active-class="transition-all duration-100 ease-out" leave-active-class="transition-all duration-100 ease-in" enter-class="scale-75 opacity-0"
                enter-to-class="scale-100 opacity-100" leave-class="scale-100 opacity-100" leave-to-class="scale-75 opacity-0">
                <div v-if="context.open" class="absolute right-0 w-64 mt-2 overflow-hidden origin-top-right bg-white border rounded-lg shadow-md">
                    <ul>
                        <li>
...
```

Only three things to note here:

1. We tell our component that we can access the scope by using the variable `context` (`slot-scope="context"`). Now we have full access to those props we just bound (`:open`, `:toggleOpen`)
2. We listen for clicks to our image, and toggle the dropdown using that context: `@click="context.toggleOpen"`
3. Finally, we hide the dropdown elements: `v-if="context.open"`

#### THAT'S IT!

You now have a fully functioning dropdown in Vue, with styling courtesy of TailwindCSS!

Here is a codesandbox with the full example!
(https://codesandbox.io/s/tailwind-vue-dropdown-example-9vx4y)


## Fin

The full working example (with each step as a branch) can be found in my [github.com/jwbaldwin](https://github.com/jwbaldwin)

If you liked this and want to see more stuff like it, feel free to follow me on twitter @jwbaldwin_ or head over to [my blog](www.jwbaldwin.com) where I share these posts :)

Thanks!

















