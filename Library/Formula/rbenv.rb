require 'formula'

class Rbenv < Formula
  homepage 'https://github.com/sstephenson/rbenv'
  url 'https://github.com/sstephenson/rbenv/archive/v0.4.0.tar.gz'
  sha1 '825ceec55805b8bb80a6d6003fd3cef824d7ff14'

  head 'https://github.com/sstephenson/rbenv.git'

  def install
    inreplace 'libexec/rbenv', '/usr/local', HOMEBREW_PREFIX
    prefix.install Dir['*']
  end

  def caveats; <<-EOS.undent
    To use Homebrew's directories rather than ~/.rbenv add to your profile:
      export RBENV_ROOT=#{var}/rbenv

    To enable shims and autocompletion add to your profile:
      if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
    EOS
  end
end
