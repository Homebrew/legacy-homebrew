require 'formula'

class Libewf < Formula
  homepage 'http://code.google.com/p/libewf/'
  url 'https://googledrive.com/host/0B3fBvzttpiiSMTdoaVExWWNsRjg/libewf-20140427.tar.gz'
  sha1 '86af91b3357d0cb78cfbe0c2356ccb3e1c8236e9'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
