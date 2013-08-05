require 'formula'

class Exenv < Formula
  homepage 'https://github.com/mururu/exenv'
  url 'https://github.com/mururu/exenv/archive/v0.1.0.tar.gz'
  sha1 '0984b6c260e42d750c8df68c8f48c19a90dc5db9'

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
