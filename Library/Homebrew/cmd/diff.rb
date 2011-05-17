require 'formula'
require 'cmd/changelog'

module Homebrew extend self
  def diff
    @outdated_brews = outdated_brews
    name = ARGV[0]

    if name
      formula = Formula.factory name
      if formula.changelog && formula.changelog_regex
        unless @outdated_brews[name]
          onoe "#{name} is up to date. try `brew changelog #{name}`"
        else
          puts latest_changes(formula)
        end
      else
        onoe "#{name} must have both a changelog url and regex defined, please ask the formula maintainer to add them."
        puts PLEASE_REPORT_BUG
        exit 1
      end
    else
      @outdated_brews.values.collect(&:last).each do |formula|
        puts latest_changes(formula)
      end
    end
  end

  def latest_changes(formula)
    keg = @outdated_brews[formula.name].first
    latest_installed_version = keg.cd{ Dir['*'] }.last

    ohai "#{formula.name} (#{latest_installed_version} < #{formula.version})"
    changelog_path = download_changelog formula

    never_matched_version = true
    String.new.tap do |changelog_diff|
      # Assuming the changelog is in reverse-chronological order, bad?
      File.open(changelog_path, 'r').lines.each do |line|
        match = line.match(formula.changelog_regex)
        if match && match[1] == latest_installed_version
          never_matched_version = false
          break
        else
          changelog_diff << line
        end
      end

      if never_matched_version
        onoe "Never matched the latest installed version number, the formula's changelog regex is probably incorrect."
        puts PLEASE_REPORT_BUG
        changelog formula.name
        exit 1
      end
    end
  end
end
