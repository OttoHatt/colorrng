# Color RNG

## Synopsis

This is a simple RNG clicker programmed with the [Nevermore](https://github.com/Quenty/NevermoreEngine) ecosystem. Originally a "narrative" game jammed in 48 hours, I've excised the core gameplay package for this release. It has a datastore-backed inventory, unboxing logic, and animated UI.

## Media

![Animated view of the color unboxing sequence.](/.github/anim1.gif)
![Open inventory menu, displaying the user's collected colors.](/.github/screen2.png)

## Running

```
npm i
rojo serve
```
Minimal setup required; sync Rojo into a blank baseplate, publish, and enable "in-Studio API access".

## Authoring

Nevermore projects are split into independently installable "packages", so code is written to allow an unknown quantity of modules to "negotiate" state. Control of the RNG gameplay is exposed via these "decoupling" patterns: namely `Signal` and `StateStack`. They add complexity, so I don't recommend introducing them unless necessary. As an exercise, you could try refactoring services in this project to manage state with private `ValueObject`s instead.

The UI is not tied to gameplay code, allowing faster testing and iteration via [Hoarcekat](https://github.com/Kampfkarren/hoarcekat) stories. Exploring [MVC in the context of Nevermore](https://youtu.be/ccRydE3HN4Q) may help you architect this.

You can install [RobloxLsp](https://github.com/NightrainsRbx/RobloxLsp) along with [this plugin](https://github.com/Meta-Maxim/RobloxLsp-Require-by-Name) to get intellisense from string requires.

Note there's some boilerplate in writing Nevermore modules. Snippets for services, `BaseObject`s, `Binder`s, etc. are helpful.

## License

This project is intended as a learning resource, hence its restrictive AGPL V3 license.