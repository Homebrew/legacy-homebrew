require 'formula'

class Cpptest < Formula
  homepage 'http://cpptest.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/cpptest/cpptest/cpptest-1.1.1/cpptest-1.1.1.tar.gz'
  sha1 '5c791746ecb0f18a5e4f15f8a57bf9e433399ebb'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
