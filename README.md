# gml-raptor - WORK IN PROGRESS - BUILDING UP THE REPO CURRENTLY!

[![gmlogo](https://user-images.githubusercontent.com/19487451/167885369-a5ae0b14-9176-4429-babd-2a140ab5880a.png)](https://gamemaker.io)<br>&nbsp;&nbsp;Studio 2.3+

<p align="center"><img src="https://user-images.githubusercontent.com/19487451/174725914-44c47daa-1d3b-4664-94ef-65f2574cba48.png" style="display:block; margin:auto; width:256px"></p>

`raptor` is a collection of objects, (struct)classes and utility functions that I use to write games.<br/>
This repository contains a ready-to-use project template in yyz format ready to be downloaded as release from (todo:create link)here.

## Main Features

|![gms](https://user-images.githubusercontent.com/19487451/174742864-ca80b221-8799-42f0-851d-474ebbbf06be.png)|![gms](https://user-images.githubusercontent.com/19487451/174742864-ca80b221-8799-42f0-851d-474ebbbf06be.png)|
|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------|
|![savegame](https://user-images.githubusercontent.com/19487451/174740590-e7dbfb58-230a-4f26-8b43-aa8cec9e905e.png) **Savegames**<br/>Have your data saved and restored with optional encryption|![race](https://user-images.githubusercontent.com/19487451/174740589-3ac7e7ac-2540-4344-9bac-862d64e584b1.png) **Race** -- The **Ra**ndom **C**ontent **E**ngine<br/>Loot, Random maps, Dice, all that can be random with json-based config|
|![state](https://user-images.githubusercontent.com/19487451/174740591-913c45ea-8d75-4a8a-a639-87565130d1b8.png) **State Machines**<br/>Easy to use but powerful game object control|![animation](https://user-images.githubusercontent.com/19487451/174740587-73d1c7ef-2e72-41d2-bda8-720910b07ec7.png) **Animations**<br/>Runtime sprite animations with triggers and runtime tweaks|
|![ui](https://user-images.githubusercontent.com/19487451/174740598-d524fc94-a05d-4b61-a5f2-dff70b320134.png) **UI and Localization**<br/>Basic UI Controls objects incl. Text Input, json-localization, 100% [Scribble](https://github.com/JujuAdams/scribble)-based|![tools](https://user-images.githubusercontent.com/19487451/174740595-72050233-4d26-49f0-96e4-9ca743210a71.png) **Tools**<br/>Utils and helpers, like Object Pools, Effects, struct & array enhancements, Message broadcasting|

---

**Important! Please read (TLDR)**

There are many objects and scripts in this library and to get going with this platform, you should take the time to read the basic concepts that this platform follows in the [Wiki](https://github.com/Grisgram/gml-raptor/wiki).

---

I tried to isolate some of the classes and make smaller repositories of it, but I failed. They work too good together and, as an example, to isolate my savegame-system out into its own repository and removing all the dependencies would've required to sacrifice lots of its functionality. Same is true for the StateMachine or the Animation system. So, after thinking about it for some time, I decided to make it public "as-it-is". It's a set of working-together parts, that allows you to speed up your game development process.

If you have questions, feedback or just want to discuss specific parts of this platform, just open a new thread in the (todo:create link)discussions for this repository. I'll do my best to answer any questions as quick as possible!
Feel free to fork, advance, fix and do what you want with the code in this repository, but please respect the MIT License and credit.<br/>


### CONTRIBUTING
I am happy, if you want to support `raptor` to become even better, just launch a pull request, explain me your changes, and I make sure, you get credited as contributor.


## Other libraries
My main goal is to provide a ready-to-use project template. I am not a big friend of "oh, yes, this is the classes, but you need to download this from here and that other thing from there and make sure, you apply this and this and this setting and best do a npm xy to have this running..." what a mess!
I do not like that. You will always find a single-download-and-run release in the template.

That being said, it leads to this requirement/fact:<br/>
`raptor` contains some other libraries that are referenced from my classes, so they are packaged together with this project template.

Some of these 'other libraries' are my own and are by default also included in the package, because I find it more easy to remove one not required folder by a simple hit of the 'Delete' key instead of browsing the file system for all bread crumbs that need to be added. It just saves time.

By default, these libraries of mine are included:

* [Outline Shader Drawer](https://github.com/Grisgram/gml-outline-shader-drawer)
* [Animated Flag](https://github.com/Grisgram/gml-animated-flag)

## Credits
### Credits for external libraries go to 

* [@JujuAdams](https://github.com/JujuAdams) and the great community at [GameMakerKitchen Discord](https://discord.gg/8krYCqr) for the [SNAP](https://github.com/JujuAdams/SNAP) Library and [Scribble](https://github.com/JujuAdams/scribble), which I packaged into this repository and the project template.
I do my best to keep the re-packaged libraries here always at the latest version of Juju's repo.
If you prefer to look up the most recent version (or any specific version) for yourself, you find SNAP and Scribble at the links a few lines above this one.


* [@YellowAfterLife](https://github.com/YellowAfterlife) for the [Open Link in new Tab](https://yal.cc/gamemaker-opening-links-in-new-tab-on-html5/) Browser Game extension for GameMaker, which I modified a bit to fit into the platform. This extension is also packaged into the platform and ready-to-use.

### Contact me
Beside the communication channel here, you can reach me as @Haerion on the [GameMakerKitchen Discord](https://discord.gg/8krYCqr).


