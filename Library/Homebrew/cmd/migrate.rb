require "migrator"
require "formula"

module Homebrew
  def migrate
    raise FormulaUnspecifiedError if ARGV.named.empty?

    # TODO implent tap formula migrations
    # TODO error if migrate formula without oldname
    ARGV.renamed_formulae_with_oldnames.each do |formula, oldname|
      puts "#{formula.name}, #{oldname}"
      migrator = Migrator.new(formula, oldname)
      migrator.migrate
    end
  end
end
