require 'colors'
path = require 'path'
fs   = require 'fs'
eco  = require 'eco'
info = console.info

{Tintan, $, _, E, appXML} = {}

T = (pth) ->
  T.deps.push _ pth

  file _(pth), ->
    info 'create'.green + ' ' + pth
    jake.mkdirP path.dirname @name
    temp = E pth + '.eco'
    if fs.existsSync temp
      temp = fs.readFileSync temp, 'utf-8'
      value = eco.render temp, Tintan: Tintan
      fs.writeFileSync @name, value, 'utf-8'
    else
      jake.cpR E(pth), @name

T.deps = []

npm_install = ->
  info 'updating'.green + ' node modules'
  npm = require('child_process').spawn 'npm', ['install', '-l']
  npm.stdout.on 'data', (data)-> process.stdout.write(data)
  npm.stderr.on 'data', (data)-> process.stderr.write(data)
  npm.on 'exit', (code)=>
    fail('npm install -l: failed with code '+code) if code != 0
    complete()

class Boot

  ready: ->
    files = ['package.json', 'Jakefile.coffee', 'plugins/tintan/plugin.py']
    return false for v in files when jake.Task['boot:'+_(v)].isNeeded()
    true

  constructor: (Ti)->

    Tintan = Ti
    appXML = Tintan.appXML()
    {$} = Tintan
    {E, _} = $

    namespace 'boot', ->

      T 'plugins/tintan/plugin.py'

      desc 'Install the Tintan plugin for Titanium Studio'
      task 'plugin.py': _ 'plugins/tintan/plugin.py'


      desc 'Register plugin on tiapp.xml'
      task 'plugin.xml', ->
        plugin = appXML.plugin()
        pluginVersion = plugin?.attr('version')?.value()
        unless pluginVersion is Tintan.version
          info 'register'.green + ' tintan plugin on tiapp.xml'
          xml = appXML.doc
          plugins = xml.get './plugins'
          unless plugins
            plugins = xml.root().node 'plugins', ''
          plugin ?= plugins.node 'plugin', 'tintan'
          plugin.attr version: Tintan.version
          xml.encoding 'utf-8'
          fs.writeFileSync appXML.file(), xml.toString(), 'utf-8'
      T.deps.push 'plugin.xml'

      T 'package.json'
      desc 'Create a generic package.json'
      task 'package.json': _ 'package.json'

      T 'Jakefile.coffee'
      desc 'Create a basic Jakefile'
      task 'Jakefile.coffee': _ 'Jakefile.coffee'

      T 'tintan.config'
      desc 'Create a default config file'
      task 'tintan.config': _ 'tintan.config'
      T.deps.push 'tintan.config'

      desc 'Install node modules with npm'
      task 'npm', [_('package.json')], npm_install, async: true
      T.deps.push 'npm'

      desc 'Initialize this project to use Tintan'
      task 'init', T.deps, ->
        info 'Tintan initialized'.bold.italic
        info 'Take a look at your Jakefile.coffee'

    desc 'Upgrade node modules and Tintan plugin'
    task 'upgrade', ['boot:npm','boot:plugin.py','boot:plugin.xml'], ->
      info 'upgrade complete'.green

module.exports = (Tintan)-> new Boot Tintan
