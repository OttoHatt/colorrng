# Color RNG

## Synopsis

This is a simple RNG clicker. Originally a "narrative" game, jammed in 48 hours, I've excised the core gameplay package for this release. It has a datastore-backed inventory, unboxing logic, and animated UI. It's programmed with the [Nevermore](https://github.com/Quenty/NevermoreEngine) ecosystem. I feel it's very good, I hope this OSS release aids you in learning/utilising it!

## Media

![Animated view of the color unboxing sequence.](/.github/anim1.gif)
![Open inventory menu, displaying the user's collected colors.](/.github/screen2.png)

## Authoring

Nevermore utilises packages, so projects are often written to allow an unknown quantity of modules to "negotiate" a central state. You can see where my ommitted story package hooked in, by use of "decoupling" patterns (namely `Signal` and `StateStack`). They add complexity, so I don't recommend introducing them unless necessary. As an exercise, you could try refactoring services in this project to manage state with private `ValueObject`s.

The UI is not tied to gameplay code, allowing iteration and testing via [Hoarcekat](https://github.com/Kampfkarren/hoarcekat) stories. Exploring [MVC in the context of Nevermore](https://youtu.be/ccRydE3HN4Q) may help you architect this.

There's some boilerplate involved in writing Nevermore modules. Snippets for services, `BaseObject`s, `Binder`s, etc. are helpful. You can install [this Roblox LSP plugin](https://github.com/Meta-Maxim/RobloxLsp-Require-by-Name) to gain intellisense from string requires.

## Running

```
npm i
rojo serve
```
Minimal setup required; sync Rojo into a blank baseplate, publish, and enable "in-Studio API access".

## License

This project is intended as a learning resource, hence its restrictive AGPL V3 license.