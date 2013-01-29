# `brew readall` tries to import all formulas one-by-one.
# This can be useful for debugging issues across all formulas
# when making significant changes to formula.rb,
# or to determine if any current formulas have Ruby issues

require 'formula'
Formula.names.each do |n|
  begin
    f = Formula.factory(n)
  rescue Exception => e
    onoe "problem in #{Formula.path(n)}"
    puts e
  end
end
