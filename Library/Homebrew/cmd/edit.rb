require 'formula'

module Homebrew
  def edit
    unless (HOMEBREW_REPOSITORY/'.git').directory?
      raise <<-EOS.undent
        Changes will be lost!
        The first time you `brew update', all local changes will be lost, you should
        thus `brew update' before you `brew edit'!
        EOS
    end

    # If no brews are listed, open the project root in an editor.
    if ARGV.named.empty?
      editor = File.basename which_editor
      if editor == "mate" or editor == "subl"
        # If the user is using TextMate or Sublime Text,
        # give a nice project view instead.
        exec editor, HOMEBREW_REPOSITORY+"bin/brew",
                     HOMEBREW_REPOSITORY+'README.md',
                     HOMEBREW_REPOSITORY+".gitignore",
                    *library_folders
      else
        exec_editor HOMEBREW_REPOSITORY
      end
    else
      # Don't use ARGV.formulae as that will throw if the file doesn't parse
      paths = ARGV.named.map do |name|
        name = Formulary.canonical_name(name)
        Formula.path(name)
      end
      unless ARGV.force?
        paths.each do |path|
          raise FormulaUnavailableError, path.basename('.rb').to_s unless path.file?
        end
      end
      exec_editor(*paths)
    end
  end

  def library_folders
    Dir["#{HOMEBREW_LIBRARY}/*"].reject do |d|
      case File.basename(d) when 'LinkedKegs', 'Aliases' then true end
    end
  end
end
