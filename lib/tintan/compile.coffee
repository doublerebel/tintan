require 'colors'
fs     = require 'fs'
path   = require 'path'
coffee = require 'coffee-script'
spawn  = require('child_process').spawn

Tintan = null

compilerMap = (root, rexp, transform = ((i)->i), base = [], map = {})->
  dir = path.join.apply(path, [root].concat(base))
  fs.existsSync(dir) and fs.readdirSync(dir).forEach (f)->
    if fs.statSync(path.join(dir, f)).isDirectory()
      compilerMap(root, rexp, transform, base.concat(f), map)
    else if rexp.test(f)
      map[path.join(dir, f)] = transform(path.join.apply(path, base.concat([f])))
  map

class Coffee

  DEFAULT_OPTIONS =
    src: 'src/coffee'        # directory to take .coffee files from
    target: 'Resources'      # directory to put .js files into
    name: 'compile:coffee'   # name of the compiler task to generate


  init: (tintan, @options = {})->
    @options[k] = v for k,v of DEFAULT_OPTIONS when !@options.hasOwnProperty(k)
    options = @options

    from = Tintan.$._(options.src)
    target = Tintan.$._(options.target)
    map = @map = compilerMap from, /\.coffee$/, (f)-> path.join(target, f).replace(/\.coffee$/, '.js')

    compile = @compile
    sources = (s for s of map)
    return false if sources.length == 0
    compiled = (c for s, c of map)

    for s, c of map
      file c, [s], (->
        compile @prereqs[0], @name, -> complete()
      ), async: true

    Tintan.$.onTaskNamespace options.name, (name)->
      desc "Compile coffee-script sources into #{options.target}"
      task name, compiled, ->
        console.log 'compiled'.green + ' coffee-script sources into ' + options.target

    Tintan.$.onTaskNamespace options.name + ':clean', ->
      desc "Clean coffee-script produced files from #{options.target}"
      task 'clean', ->
        fs.unlink c for c in compiled

    Tintan.$.onTaskNamespace options.name + ':watch', =>
      desc "Watch coffee-script files in #{options.src} for changes and compile them into #{options.target}"
      task 'watch', =>
        c = spawn '' + @getCoffeePath(), "--compile --watch --output #{options.target} #{options.src}".split(' ')
        c.stdout.on 'data', (data)-> process.stdout.write data
        c.stderr.on 'data', (data)-> process.stderr.write data
    true

  compile: (source, target, cb)=>
    jake.file.mkdirP path.dirname(target)
    c = fs.readFileSync source, 'utf-8'
    try
      iced = Tintan.config().get('iced')
      coffee = require('iced-coffee-script') if iced is true
      console.log('Compiling ' + target + ' with ' + (if iced then 'iced-' else '') + 'coffee-script' ) if Tintan.config().get('verbose') is true
      j = coffee.compile c
      fs.writeFileSync target, j, 'utf-8'
    catch err
      process.stderr.write "Error compiling #{source}\n"
      process.stderr.write err.toString() + "\n"
      fail("Error compiling #{source}\n")
    cb()

  getCoffeePath: ->
    coffeePath = ''
    result = ''
    if Tintan.config().get('iced') is true
      coffeePath = require.resolve('iced-coffee-script')
    else
      coffeePath = require.resolve('coffee-script')

    newCoffeePath = coffeePath.split('/')
    # ../../../
    newCoffeePath.pop()
    newCoffeePath.pop()
    newCoffeePath.pop()
    # /bin/coffee
    newCoffeePath.push('bin')
    newCoffeePath.push('coffee')

    for dir in newCoffeePath
      if dir is ''
        continue
      else
        result += '/'
        result += dir

    return result

  invokeTask: ->
    jake.Task[@options.name].invoke()

  invokeClean: ->
    jake.Task[@options.name + ':clean'].invoke()


Compilers =
  coffee: Coffee

module.exports = (tintan)->

  Tintan = tintan.constructor

  compilers = []

  desc 'Compile sources'
  task 'compile', ->
    compiler.invokeTask() for compiler in compilers


  tintan.compile = (lang, args...)->
    Compiler = Compilers[lang]
    fail "Dont know how to compile #{lang}".red unless Compiler
    compiler = new Compiler
    compilers.push compiler if compiler.init.apply compiler, [tintan].concat(args)
