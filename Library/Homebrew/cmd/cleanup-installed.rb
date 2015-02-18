# DEPRECATED in favour of https://github.com/Homebrew/homebrew-brewdler
#
# brew-cleanup-installed: uninstall all non-whitelisted Homebrew formulae.
#
# Useful for maintainers/testers who regularly install lots of formulae
# they don't actually use.
#
# Populate ~/.brew-cleanup-installed with the formulae you want to keep
# installed. All others will be uninstalled when brew-cleanup-installed is run.

module Homebrew
  def cleanup_installed
    opoo <<-EOS.undent
      brew cleanup-installed is deprecated and will be removed soon!

      Please consider using the `brew brewdle dump` and `brew brewdle cleanup`
      commands from https://github.com/Homebrew/homebrew-brewdler
    EOS
    cleanup_file = Pathname.new "#{ENV["HOME"]}/.brew-cleanup-installed"
    return unless cleanup_file.exist?

    kept_formulae = cleanup_file.read.lines.map(&:strip)
    current_formulae = `brew list`.lines.map(&:strip)
    uninstall_formulae = current_formulae - kept_formulae
    return if uninstall_formulae.empty?
    safe_system "brew", "uninstall", "--force", *uninstall_formulae
  end
end
