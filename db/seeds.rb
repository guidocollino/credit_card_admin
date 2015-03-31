# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#Razones de uso de las tarjetas
ReasonOfUse.create( name: "Saldo", priority: 1,  description: "Es un saldo a favor que queda de una autorizacion que se pidio por mas de los que se uso")
ReasonOfUse.create( name: "Error", priority: 2,  description: "Es un error interno de Aero")
ReasonOfUse.create( name: "Débito", priority: 3,  description: "Es un tarjeta que vino rechazada")
ReasonOfUse.create( name: "Favor", priority: 4,  description: "Es un favor que se la hace a la agencia")
