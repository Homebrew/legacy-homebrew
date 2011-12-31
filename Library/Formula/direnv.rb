require 'formula'

class Direnv < Formula
  homepage 'http://www.direnv.net'
  url 'https://github.com/zimbatm/direnv/tarball/v0.1.108'
  md5 'de4f7eb31cebba4c220c200df1c99e5c'

  head 'https://github.com/zimbatm/direnv.git'

  def install
    system("make install DESTDIR=#{prefix}")
  end

  def caveats
    <<-EOS.undent
    One last step.

    At the END of your ~/.bashrc or ~/.zshrc, add the following line:

      eval `direnv hook $0`

    I mean, AFTER rvm, git-prompt and friends :)

    Reload your shell, done.

    See the wiki for docs and examples:
      https://github.com/zimbatm/direnv/wiki/
    EOS
  end
end
