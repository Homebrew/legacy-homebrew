require 'formula'

class Hercules < Formula
  url 'http://www.hercules-390.org/hercules-3.07.tar.gz'
  homepage 'http://www.hercules-390.org/'
  sha1 'd0b2e543dd66ee43576e5a5faff8f4cc061cffb4'

  depends_on 'gawk'

  def install
    # Since Homebrew optimizes for us, tell Hercules not to.
    # (It gets it wrong anyway.)
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-optimization=no"
    system "make"
    system "make install"
  end
end
