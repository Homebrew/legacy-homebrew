require 'formula'

class Rbenv < Formula
  homepage 'https://github.com/sstephenson/rbenv'
  url 'https://github.com/sstephenson/rbenv/tarball/v0.3.0'
  sha1 'b9f78b1a10d4e225d0377cac33c1a964ee6df00b'

  head 'https://github.com/sstephenson/rbenv.git'

  def install
    prefix.install Dir['*']
  end

  def caveats; <<-EOS.undent
    To enable shims and autocompletion, add rbenv init to your profile:
      if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
    EOS
  end
end
