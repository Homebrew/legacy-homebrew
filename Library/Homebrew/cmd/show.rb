module Homebrew extend self
  def show
    require 'formula'
    cd HOMEBREW_REPOSITORY
    formulae = ARGV.send(:downcased_unique_named).map do |name|
      begin
        Formula.factory name
      rescue FormulaUnavailableError
      end
    end.compact
    formulae.each do |f|
      system 'git', 'log', '-1', '-p', *(ARGV.options_only + ['--', f.path])
    end
    revs = ARGV.named - formulae.map(&:name)
    revs = ['HEAD'] if formulae.empty? && revs.empty?
    revs.each do |r|
      system 'git', 'show', *ARGV.options_only << r
    end
  end
end
