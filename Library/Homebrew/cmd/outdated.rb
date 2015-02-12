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
      same_tap_versions = []
      f.rack.subdirs.each do |dir|
        keg = Keg.new dir
        version = keg.version
        all_versions << version
        same_or_head_version = f.version == version || version.head?

        tap = Tab.for_keg(keg).tapped_from
        same_or_path_url_tap = f.tap == tap || tap == HOMEBREW_PATH_URL_TAP
        if same_or_path_url_tap || same_or_head_version
          same_tap_versions << version
        end
      end

      if same_tap_versions.all? { |version| f.pkg_version > version }
        yield f, all_versions if block_given?
        f
      end
    end.compact
  end
end
