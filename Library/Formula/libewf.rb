require 'formula'

class Libewf < Formula
  homepage 'http://code.google.com/p/libewf/'
  url 'http://libewf.googlecode.com/files/libewf-20130105.tar.gz'
  sha1 '9d8ba42e6a111737093a782829b5f74ab44bece4'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
