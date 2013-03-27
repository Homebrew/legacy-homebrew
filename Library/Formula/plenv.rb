require 'formula'

class Plenv < Formula
  homepage 'https://github.com/tokuhirom/plenv'
  url 'https://github.com/tokuhirom/plenv/tarball/1.4.7'
  sha1 '04884fdf5a4e4e72543203038bd9e75ee2974bdd'

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
