require 'formula'

class Liquidprompt < Formula
  homepage 'https://github.com/nojhan/liquidprompt'
  url 'https://github.com/nojhan/liquidprompt/archive/v_1.7.tar.gz'
  sha1 'db7f24b20f09480b3491c5250f30f7ccd67ee44e'

  def install
    (share+'liquidprompt').install 'liquidpromptrc-dist'
    bin.install 'liquidprompt'
  end

  def caveats; <<-EOS.undent
    Add the following lines to your bash or zsh config (e.g. ~/.bash_profile):
      if [ -f $(brew --prefix)/bin/liquidprompt ]; then
        . $(brew --prefix)/bin/liquidprompt
      fi

    If you'd like to reconfigure options, you may do so in ~/.liquidpromptrc.
    A sample file you may copy and modify has been installed to
      #{HOMEBREW_PREFIX}/share/liquidprompt/liquidpromptrc-dist

    Don't modify the PROMPT_COMMAND variable elsewhere in your shell config;
    that will break things.
    EOS
  end
end
