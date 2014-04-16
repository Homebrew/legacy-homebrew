require 'formula'

class Hercules < Formula
  homepage 'http://www.hercules-390.eu/'
  url 'http://downloads.hercules-390.eu/hercules-3.10.tar.gz'
  sha1 '10599041c7e5607cf2e7ecc76802f785043e2830'

  skip_clean :la

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
