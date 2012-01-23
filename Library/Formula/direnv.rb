require 'formula'

class Direnv < Formula
  homepage 'https://github.com/zimbatm/direnv'
  url 'https://github.com/zimbatm/direnv/tarball/v0.1.81'
  md5 '9429548fbf48ec56ff1d11bf601ed649'

  head 'https://github.com/zimbatm/direnv.git'

  def install
    # App and support files live in libexec
    libexec.install Dir['libexec/*']
    # Symlink into bin
    bin.mkpath
    ln_s libexec+'direnv', bin+'direnv'
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
