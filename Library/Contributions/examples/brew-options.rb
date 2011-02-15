compact = ARGV.include? '--compact'

nf = ARGV.formulae.length
ARGV.formulae.each_with_index do |f, i|
  f.options rescue next
  if compact
    if nf > 1
      puts f.name + ':'
    end
    puts f.options.collect {|o| o[0]} * " "
  else
    puts f.name + ':'
    f.options.each do |o|
      puts o[0]
      puts wrap_text_in4(o[1])
    end
    if i < nf-1
      puts
    end
  end
end
