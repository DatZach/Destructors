# GML2.3 Destructors

This library adds destructors to GameMaker: Studio 2.3's release. This allows you to use `ds_*` types such as `list`s and `map`s inside of `struct`s without fear of leaking memory when they're deleted.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Installation via Local Package (.yymps)

GameMaker Studio 2 allows you to import assets, including scripts and shaders, directly into your project via the "Local Package" system. From the [Releases](https://github.com/DatZach/Destructors/releases) tab for this repo, download the .yymp file for the latest version. In the GMS2 IDE, load up your project and click on "Tools" on the main window toolbar. Select "Import Local Package" from the drop-down menu then import all scripts from the Destructors package.

### Installation via Copy/Paste

You can simply copy and paste the contents of (Destructors.gml)[https://github.com/DatZach/Destructors/blob/master/scripts/Destructors/Destructors.gml] into a new Script in your project.

### Usage

The following code should be called inside of the `Step` event of a persistent object, created in the first room of your game. This is typically your Game Controller object.
```javascript
dtor.update();
```

Destructors are registered via the `dtor_track(type, value, [option])` function. This function can be called multiple times on the same struct instance to registered multiple destructors.

In order to register a destructor callback,

*Note that struct members cannot be accessed inside of the callback.*
```javascript
function foo() constructor {
	name = "Zach";
	
	dtor_track(DtorType.Function, function () {
		show_debug_message("Destructed!");
	});
}

var a = new foo();
delete a;           // "Destructed!"
```

In order to register a destructor to clean an allocated `ds_*`,
```javascript
function test1() constructor {
    list = ds_list_create();

    dtor_track(DtorType.List, list);
}

var a = new test1();  // foo.list exists
delete a;             // foo.list has been destroyed
```

Additionally, `Sprite`, `Surface`, `VertexBuffer`, `VertexFormat`, `Path`, `AnimCurve` and `Instance` types can be destroyed via `dtor_track`.

## Running the Example

Clone this repo and open and run the project in GameMaker: Studio. Follow the on screen instructions for a demonstration of the library.

## Authors

* **Zach Reedy** - *Developed first implementation. Finalized codebase.* - [DatZach](https://github.com/DatZach)
* **JuJu Adams** - *Second draft implementation. Examples.* - [JujuAdams](https://github.com/JujuAdams)
* **Torin Freimiller** - *Initial discoveries related to tracking objects.* - [Nommiin](https://github.com/nommiin)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
