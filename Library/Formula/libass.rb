require 'formula'

class Libass < Formula
  url 'http://libass.googlecode.com/files/libass-0.10.0.tar.gz'
  homepage 'http://code.google.com/p/libass/'
  md5 '05cc8cc5eb4265b55ab0821f0825b719'

  depends_on 'pkg-config' => :build
  depends_on 'fribidi'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
