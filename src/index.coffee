# Dependencies
caravan= require './caravan'
objectAssign= require 'object-assign'

# singleton & constructor
API= -> caravan.request arguments...
API= objectAssign API,caravan

module.exports= API
