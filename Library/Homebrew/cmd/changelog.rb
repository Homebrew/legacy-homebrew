require 'formula'

module Homebrew extend self
  def changelog(name = ARGV[0])
    formula = Formula.factory name
    safe_system "less", download_changelog(formula)
  end

  def download_changelog(formula)
    strategy = detect_download_strategy formula.changelog
    downloader = strategy.new(formula.changelog, "#{formula.name}_changelog", formula.version, nil)
    downloader.fetch
  end
end
