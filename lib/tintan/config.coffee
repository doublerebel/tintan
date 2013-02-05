module.exports = (tintan) ->
	Tintan = tintan.constructor

	config_options = []

	desc 'Configure Tintan'
	task 'config', ->
		global.config.prompt(option) for option in config_options

	namespace 'config', ->

		desc 'Initialize options to default values.'
		task 'init', ->
			Tintan.config().init()

		desc 'Show value of all options'
		task 'display', ->
			Tintan.config().display()

