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
      all_versions = []
      older_or_same_tap_versions = []
      f.rack.subdirs.each do |dir|
        keg = Keg.new dir
        version = keg.version
        all_versions << version
        older_version = f.pkg_version <= version

        tap = Tab.for_keg(keg).tap
        if tap.nil? || f.tap == tap || older_version
          older_or_same_tap_versions << version
        end
      end

      if older_or_same_tap_versions.all? { |version| f.pkg_version > version }
        yield f, all_versions if block_given?
        f
      end
    end.compact
  end
end
