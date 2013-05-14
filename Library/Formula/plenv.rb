require 'formula'

class Plenv < Formula
  homepage 'https://github.com/tokuhirom/plenv'
  url 'https://github.com/tokuhirom/plenv/archive/1.4.15.tar.gz'
  sha1 '34c8524b990010c6d1d1d8508b880904b327fe03'

  head 'https://github.com/tokuhirom/plenv.git'

  def install
    prefix.install 'bin', 'share'
  end

  def caveats; <<-EOS.undent
    To enable shims add to your profile:
      if which plenv > /dev/null; then eval "$(plenv init -)"; fi
    EOS
  end
end
