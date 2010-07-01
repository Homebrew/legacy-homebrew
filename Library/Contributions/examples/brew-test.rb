ARGV.formulae.each do |f|
  # Cannot test uninstalled formulae
  unless f.installed?
    puts "#{f.name} not installed"
    next
  end

  # Cannot test formulae without a test method
  unless f.respond_to? :test
    puts "#{f.name} defines no test"
    next
  end

  puts "Testing #{f.name}"
  begin
    f.test
  rescue
    puts "#{f.name}: failed"
  end
end
