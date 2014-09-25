require 'formula'

class Calcurse < Formula
  homepage 'http://calcurse.org/'
  url 'http://calcurse.org/files/calcurse-3.2.1.tar.gz'
  sha1 'ae5b128074c294be7651e025b7e0fdfc15259085'

  depends_on 'gettext'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
