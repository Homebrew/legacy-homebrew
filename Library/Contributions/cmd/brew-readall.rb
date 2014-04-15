# `brew readall` tries to import all formulae one-by-one.
# This can be useful for debugging issues across all formulae
# when making significant changes to formula.rb,
# or to determine if any current formulae have Ruby issues

require 'formula'
require 'cmd/tap'

formulae = []
if ARGV.empty?
  formulae = Formula.names
else
  tap_name = ARGV.first
  # Allow use of e.g. homebrew/versions or homebrew-versions
  tap_dir = tap_name.reverse.sub('/', '-').reverse
  tap = Pathname("#{HOMEBREW_LIBRARY}/Taps/#{tap_dir}")
  raise "#{tap} does not exist!" unless tap.exist?
  tap.find_formula do |f|
    formulae << tap/f
  end
end

formulae.sort.each do |n|
  begin
    Formula.factory(n)
  rescue Exception => e
    onoe "problem in #{Formula.path(n)}"
    puts e
    Homebrew.failed = true
  end
end
