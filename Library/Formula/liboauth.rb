require 'formula'

class Liboauth < Formula
  homepage 'http://liboauth.sourceforge.net'
  url 'http://sourceforge.net/projects/liboauth/files/liboauth-1.0.0.tar.gz'
  sha1 'cc936a440084f159cc46dab9018f1353f8bee80a'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--disable-curl", "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "false"
  end
end
