ARGV.formulae.each do |f|
  f.options rescue next
  puts f.name
  f.options.each do |o|
    puts o[0]
    puts "\t"+o[1]
  end
  puts
end
