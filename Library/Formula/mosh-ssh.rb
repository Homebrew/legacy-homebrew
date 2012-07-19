require 'formula'

class MoshSsh < Formula
  homepage 'http://mosh.mit.edu/'
  url 'https://github.com/downloads/keithw/mosh/mosh-1.2.2.tar.gz'
  sha1 'f0227800298d80e9f1353db3b29a807de833d7d2'

  depends_on 'protobuf'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install" # if this fails, try separate make/make install steps
  end

  def test
    system "mosh -v"
  end
end
