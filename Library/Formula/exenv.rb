require 'formula'

class Exenv < Formula
  homepage 'https://github.com/mururu/exenv'
  url 'https://github.com/mururu/exenv/archive/v0.1.0.tar.gz'
  sha1 '2a796bca35136e2abc24a5fe2868dec3858edd3c'
  head 'https://github.com/mururu/exenv.git'

  def install
    inreplace 'libexec/exenv', '/usr/local', HOMEBREW_PREFIX
    prefix.install Dir['*']
  end

  def caveats; <<-EOS.undent
    To use Homebrew's directories rather than ~/.exenv add to your profile:
      export EXENV_ROOT=#{var}/exenv

    To enable shims and autocompletion add to your profile:
      if which exenv > /dev/null; then eval "$(exenv init -)"; fi
    EOS
  end
end
