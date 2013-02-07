require 'formula'

class Plenv < Formula
  homepage 'https://github.com/tokuhirom/plenv'
  url 'https://github.com/tokuhirom/plenv/tarball/1.4.0'
  sha1 '1019c2ee9fb16a1fff2cc2f8830d98bdbfdd334b'

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
