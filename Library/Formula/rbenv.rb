require 'formula'

class Rbenv < Formula
  homepage 'https://github.com/sstephenson/rbenv'
  url 'https://github.com/sstephenson/rbenv/tarball/v0.4.0'
  sha1 'a5e80249f985294c1c9f0914f7cbdc85d4cadd74'

  head 'https://github.com/sstephenson/rbenv.git'

  def install
    inreplace 'libexec/rbenv', '/usr/local', HOMEBREW_PREFIX
    prefix.install Dir['*']
  end

  def caveats; <<-EOS.undent
    To enable shims and autocompletion add to your profile:
      if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

    To use Homebrew's directories rather than ~/.rbenv add to your profile:
      export RBENV_ROOT=#{var}/rbenv
    EOS
  end
end
