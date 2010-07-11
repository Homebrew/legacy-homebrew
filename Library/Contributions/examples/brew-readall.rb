# `brew readall` tries to import all formulae one-by-one.
# This can be useful for debugging issues across all formulae
# when making significant changes to formula.rb

require 'formula'
names = []
Formulary.read_all { |name, klass| names << name }
