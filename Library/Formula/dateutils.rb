require 'formula'

class Dateutils < Formula
  homepage 'http://www.fresse.org/dateutils/'
  url 'https://bitbucket.org/hroptatyr/dateutils/downloads/dateutils-0.2.6.tar.xz'
  sha1 '55709a7a259bf73fb9ff7bb62de7a31a894870ed'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
