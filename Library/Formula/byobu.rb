require 'formula'

class Byobu < Formula
  homepage 'http://launchpad.net/byobu'
  url 'https://launchpad.net/byobu/trunk/5.21/+download/byobu_5.21.orig.tar.gz'
  sha1 '81ed721b643addf84c7aba10f173c27dc69391bd'

  depends_on 'coreutils'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end

  def caveats; <<-EOS.undent
    Add the following to your shell configuration file:
      export BYOBU_PREFIX=$(brew --prefix)
    EOS
  end
end
