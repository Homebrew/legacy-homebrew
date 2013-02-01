require 'formula'

class Plenv < Formula
  homepage 'https://github.com/tokuhirom/plenv'
  url 'https://github.com/tokuhirom/plenv/tarball/1.1.0'
  sha1 'b7f2d72022fa8db36fe8cb9b4f3d351a845b1d34'

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
