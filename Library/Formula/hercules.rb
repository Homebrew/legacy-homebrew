require 'formula'

class Hercules < Formula
  url 'http://www.hercules-390.org/hercules-3.07.tar.gz'
  homepage 'http://www.hercules-390.org/'
  md5 'a12aa1645b0695b25b7fc0c9a3ccab3a'

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
