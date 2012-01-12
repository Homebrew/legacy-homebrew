require 'formula'

module Homebrew extend self
  def edit
    # If no brews are listed, open the project root in an editor.
    if ARGV.named.empty?
      editor = which_editor
      if editor == "mate"
        # If the user is using TextMate, give a nice project view instead.
        exec 'mate', HOMEBREW_REPOSITORY+"bin/brew",
                     HOMEBREW_REPOSITORY+'README.md',
                     HOMEBREW_REPOSITORY+".gitignore",
                    *library_folders
      else
        exec_editor HOMEBREW_REPOSITORY
      end
    else
      # Don't use ARGV.formulae as that will throw if the file doesn't parse
      paths = ARGV.named.map do |name|
        HOMEBREW_REPOSITORY+"Library/Formula/#{Formula.canonical_name name}.rb"
      end
      unless ARGV.force?
        paths.each do |path|
          raise FormulaUnavailableError, path.basename('.rb').to_s unless path.file?
        end
      end
      exec_editor *paths
    end
  end

  def library_folders
    Dir["#{HOMEBREW_REPOSITORY}/Library/*"].reject do |d|
      case File.basename(d) when 'LinkedKegs', 'Aliases' then true end
    end
  end
end
