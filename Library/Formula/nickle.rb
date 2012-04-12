require 'formula'

class Nickle < Formula
  url 'http://nickle.org/release/nickle-2.70.tar.gz'
  homepage 'http://www.nickle.org/'
  md5 'fbb77ad1c6f80a9a67ae28a2a678ed67'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
