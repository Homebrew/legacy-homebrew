require "formula"
require "keg"

module Homebrew
  def outdated
    formulae = ARGV.resolved_formulae.any? ? ARGV.resolved_formulae : Formula.installed
    if ARGV.json == "v1"
      outdated = print_outdated_json(formulae)
    else
      outdated = print_outdated(formulae)
    end
    Homebrew.failed = ARGV.resolved_formulae.any? && outdated.any?
  end

  def print_outdated(formulae)
    verbose = ($stdout.tty? || ARGV.verbose?) && !ARGV.flag?("--quiet")

    formulae.select(&:outdated?).each do |f|
      if verbose
        puts "#{f.full_name} (#{f.outdated_versions*", "} < #{f.pkg_version})"
      else
        puts f.full_name
      end
    end
  end

  def print_outdated_json(formulae)
    json = []
    outdated = formulae.select(&:outdated?).each do |f|

      json << { :name => f.full_name,
                :installed_versions => f.outdated_versions.collect(&:to_s),
                :current_version => f.pkg_version.to_s }
    end
    puts Utils::JSON.dump(json)

    outdated
  end
end
