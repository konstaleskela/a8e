# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

schools = [
  'Kerttulin lukio',
  'Puolalanmäen lukio',
  'Turun klassillinen lukio',
  'Turun Lyseon lukio',
]
schools.each do |name|
  School.create(name: name)
end

Event.create({
  :name => "Abi Goes Tallinn 2016",
});
