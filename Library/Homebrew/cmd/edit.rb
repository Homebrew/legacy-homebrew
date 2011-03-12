require 'formula'

module Homebrew extend self
  def edit
    if ARGV.named.empty?
      # EDITOR isn't a good fit here, we need a GUI client that actually has
      # a UI for projects, so apologies if this wasn't what you expected,
      # please improve it! :)
      exec 'mate', HOMEBREW_REPOSITORY+"bin/brew",
                   HOMEBREW_REPOSITORY+'README.md',
                   HOMEBREW_REPOSITORY+".gitignore",
              *Dir[HOMEBREW_REPOSITORY+"Library/*"]
    else
      # Don't use ARGV.formulae as that will throw if the file doesn't parse
      paths = ARGV.named.map do |name|
        HOMEBREW_REPOSITORY+"Library/Formula/#{Formula.caniconical_name name}.rb"
      end
      unless ARGV.force?
        paths.each do |path|
          raise FormulaUnavailableError, path.basename('.rb').to_s unless path.file?
        end
      end
      exec_editor *paths
    end
  end
end
