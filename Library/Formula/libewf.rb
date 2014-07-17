require 'formula'

class Libewf < Formula
  homepage 'http://code.google.com/p/libewf/'
  url 'https://googledrive.com/host/0B3fBvzttpiiSMTdoaVExWWNsRjg/libewf-20140608.tar.gz'
  sha1 'c17384a3d2c1d63bd5b1aaa2aead6ee3c82a2368'

  bottle do
    cellar :any
    sha1 "3af34e429a24ced715c1563ba62c28dfd5a6201e" => :mavericks
    sha1 "526b99662ca1a873b0a44e56cf2b88f4d0d1744b" => :mountain_lion
    sha1 "b7de02361dfd59585f352ff74da02a9008d06884" => :lion
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
