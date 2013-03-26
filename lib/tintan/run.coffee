module.exports = (tintan)->
  Tintan = tintan.constructor

  namespace 'run', ->

    if Tintan.appXML().targets 'android'
      desc 'Run the Android emulator'
      task 'emulator', ->
        # default to config options unless supplied by environment vars
        android_device = Tintan.config().get('android_device')
        android_device = jake.program.envVars['android_device'] if jake.program.envVars.hasOwnProperty('android_device')

        Tintan.$.tipy ['android', 'builder.py'], 'emulator',
          Tintan.appXML().name(), Tintan.$.android_home(), process.cwd(), Tintan.appXML().id(),
          Tintan.$.android_version(), android_device

    if Tintan.appXML().targets 'android'
      desc 'Run the application on Android emulator' # with debugging'
      task 'android', ->
        # default to config options unless supplied by environment vars
        android_device = Tintan.config().get('android_device')
        android_device = jake.program.envVars['android_device'] if jake.program.envVars.hasOwnProperty('android_device')
        debug = Tintan.config().get('debug')
        debug = jake.program.envVars['debug'] if jake.program.envVars.hasOwnProperty('debug')

        if debug is true
          debug_address = Tintan.config().get('debug_address')
          debug_address = jake.program.envVars['debug_address'] if jake.program.envVars.hasOwnProperty('debug_address')
          debug_port = Tintan.config().get('debug_port')
          debug_port = jake.program.envVars['debug_port'] if jake.program.envVars.hasOwnProperty('debug_port')
          debugString = debug_address + ':' + debug_port

          Tintan.$.tipy ['android', 'builder.py'], 'simulator',
            Tintan.appXML().name(), Tintan.$.android_home(), process.cwd(), Tintan.appXML().id(),
            Tintan.$.android_version(), Tintan.config().get('android_device'), debug_string
        else
          Tintan.$.tipy ['android', 'builder.py'], 'simulator',
            Tintan.appXML().name(), Tintan.$.android_home(), process.cwd(), Tintan.appXML().id(),
            Tintan.$.android_version(), Tintan.config().get('android_device')

    if Tintan.appXML().targets 'ipad'
      desc 'Run the application on iPad emulator'
      task 'ipad', ->
        Tintan.$.tipy ['iphone', 'builder.py'], 'run',
          process.cwd(), Tintan.$.ios_version(), Tintan.appXML().id(), Tintan.appXML().name(),
          'ipad'

    if Tintan.appXML().targets 'iphone'
      desc 'Run the application on iPhone emulator'
      task 'iphone', ->
        Tintan.$.tipy ['iphone', 'builder.py'], 'run',
          process.cwd(), Tintan.$.ios_version(), Tintan.appXML().id(), Tintan.appXML().name(),
          'iphone'
