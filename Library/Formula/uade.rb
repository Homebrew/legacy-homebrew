require 'formula'

class Uade < Formula
  homepage 'http://zakalwe.fi/uade/'
  url 'http://zakalwe.fi/uade/uade2/uade-2.13.tar.bz2'
  sha1 '61c5ce9dfecc37addf233de06be196c9b15a91d8'

  depends_on 'pkg-config' => :build
  depends_on 'libao'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
