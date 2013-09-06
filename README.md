# Tintan - Titanium development with style!

  A coffee-script based tool for adding coffee, bdd and node_modules to your Titanium development.

  <img src="https://github.com/vic/tintan/raw/master/pub/pachuco.png" title="¡Ya llegó su pachucote!" />

###  OVERVIEW

  Tintan integrates state of the art tools into your Titanium development.

  Featuring a ready to use setup for building projects with useful Jake tasks,
  being able to write applications in CofeeScript without having to worry about compiling them,
  managing your project dependencies using NPM and allowing to include node modules on your
  mobile application using ender.js


###  FEATURES

  * Painless installation and project setup.
  * Integrated build with Titanium Studio.
  * CLI (tasks) for when you feel more confortable building from the command line.
  * Allows you to write CoffeeScript sources and get them automatically compiled.
  * Integrate BDD to your development and ensure all tests succeed on production builds.
  * Include vendor node modules for using within your app by using ender.js

### INSTALLATION

```sh
  $ npm install -g tintan

  # cd /your/titanium/project

  $ tintan

  # Get an overview of available tasks
  $ tintan -T
```


### CONFIG / ENVIRONMENT VARIABLES

  `tintan config` - Configure all available options

  (creates JSON text file `tintan.config` if not present)

  `tintan config:display` - Display options and settings

  Normally Tintan will try to guess your current environment setup, you can
  however force a particular setting by setting or exporting one of the following variables:

#### Options

  * **verbose** / **VERBOSE** *boolean*

  Verbose compiling?

  default: `true`

  * **debug** / **DEBUG** *boolean*

  Wait for debugger to attach?

  default: `false`

  * **debug\_address** / **DEBUG\_ADDRESS** *String*

  IP Address for debugger connection

  default: `'127.0.0.1'`

  * **debug\_port** / **DEBUG\_PORT** *Number*

  Port for debugger

  default: `5858`

  * **iced** / **ICED** *boolean*

  Compile with Iced CoffeeScript?

  default: `false`

  * **android\_avd** / **AVD** *String*

  The Android virtual device to use for development.

  default: `null`

  * **android\_device** / **ANDROID\_DEVICE** *String*

  The Android physical device to use for development.

  default: `''`

  * **android\_sdk** / **ANDROID\_SDK** *String*

  The location of the Android development kit.

  default: Linux: `/opt/android-sdk`, Mac: the max value of `/usr/local/Cellar/android-sdk/*`, Windows: `C:\Program Files (x86)\Android\android-sdk`

  * **ios\_version** / **IOS\_VERSION** *String*

  The version of iOS to target, eg. 5.0, 6.0

  default: max value of `~/Library/Application Support/iPhone Simulator/`

  * **ti\_home** / **TI\_HOME** *String*

  The Titanium directory containing mobilesdk/ subdir.

  default: Linux: `~/.titanium`, Mac: `/Library/Application Support/Titanium`

  * **ti\_platform** / **TI\_PLATFORM** *String*

  The platform for mobile development: `'android'`, `'iphone'`, `'mobileweb'`, `'module'`

  default: Linux: `'android'`, Mac: `'iphone'`

  * **ti\_python** / **TI\_PYTHON** *String*

  The python executable to run Titanium scripts.

  default: the python found in `$PATH`

  * **ti\_sdk** / **TI\_SDK** *String*

  The version of the Titanium SDK to use.

  default: the greatest version installed on `$TI_HOME/mobilesdk`
