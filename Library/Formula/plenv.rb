require 'formula'

class Plenv < Formula
  homepage 'https://github.com/tokuhirom/plenv'
  url 'https://github.com/tokuhirom/plenv/tarball/1.0.8'
  sha1 '9babaeb2af77609a00ccdbda5a22213d7c3529dc'

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
