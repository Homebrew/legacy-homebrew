require 'formula'
require 'keg'

module Homebrew
  def outdated
    formulae = ARGV.formulae.any? ? ARGV.formulae : Formula.installed

    outdated = outdated_brews(formulae) do |f, versions|
      if ($stdout.tty? || ARGV.verbose?) && !ARGV.flag?("--quiet")
        puts "#{f.name} (#{versions*', '} < #{f.pkg_version})"
      else
        puts f.name
      end
    end
    Homebrew.failed = ARGV.formulae.any? && outdated.any?
  end

  def outdated_brews(formulae)
    formulae.map do |f|
      versions = f.rack.subdirs.map { |d| Keg.new(d).version }.sort!
        if versions.all? { |version| f.pkg_version > version }
        yield f, versions if block_given?
        f
      end
    end.compact
  end
end
