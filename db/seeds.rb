# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

schools = [
  'Katedralskolan i Åbo',
  'Kerttulin lukio',
  'Luostarivuoren lukio',
  'Puolalanmäen lukio',
  'Turun klassillinen lukio',
  'Turun Lyseon lukio',
  'Turun Normaalikoulu ja lukio',
  'Turun Steiner-koulu',
  'Turun Suomalaisen Yhteiskoulun lukio (TSYK)'
]
schools.each do |name|
  School.create(name: name)
end

Event.create({
  :name => "Abit Goes To Tallinn 2016",
});
