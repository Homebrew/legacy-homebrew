require 'formula'
require 'keg'

module Homebrew
  def outdated
    if ARGV.json == "v1"
      outdated = print_outdated_json
    else
      outdated = print_outdated
    end
    Homebrew.failed = ARGV.resolved_formulae.any? && outdated.any?
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

  def formulae_to_check
    ARGV.resolved_formulae.any? ? ARGV.resolved_formulae : Formula.installed
  end

  def print_outdated
    verbose = ($stdout.tty? || ARGV.verbose?) && !ARGV.flag?("--quiet")

    outdated_brews(formulae_to_check) do |f, versions|
      if verbose
        puts "#{f.full_name} (#{versions*', '} < #{f.pkg_version})"
      else
        puts f.full_name
      end
    end
  end

  def print_outdated_json
    json = []
    outdated = outdated_brews(formulae_to_check) do |f, versions|
      json << {:name => f.name,
               :installed_versions => versions.collect(&:to_s),
               :current_version => f.pkg_version.to_s}
    end
    puts Utils::JSON.dump(json)

    outdated
  end
end
