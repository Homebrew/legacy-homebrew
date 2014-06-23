require "formula_versions"

module Homebrew
  def versions
    raise "Please `brew install git` first" unless which "git"
    raise "Please `brew update` first" unless (HOMEBREW_REPOSITORY/".git").directory?
    raise FormulaUnspecifiedError if ARGV.named.empty?

    opoo <<-EOS.undent
      brew-versions is unsupported and may be removed soon.
      Please use the homebrew-versions tap instead:
        https://github.com/Homebrew/homebrew-versions
    EOS
    ARGV.formulae.each do |f|
      versions = FormulaVersions.new(f)
      path = versions.repository_path
      versions.each do |version, rev|
        print "#{Tty.white}#{version.to_s.ljust(8)}#{Tty.reset} "
        puts "git checkout #{rev} #{path}"
      end
    end
  end
end
