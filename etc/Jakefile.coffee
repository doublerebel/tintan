# This Jakefile was automatically created by Tintan. Edit to your hearts content.
# For more help on customizing Tintan see: http://github.com/vic/tintan

# Include Tintan tasks on this project.
Tintan = require('tintan')

# Make the default task depend on tintan:build.
task 'default', ['tintan:build']
