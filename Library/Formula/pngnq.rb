require 'formula'

class Pngnq < Formula
  url 'http://downloads.sourceforge.net/project/pngnq/pngnq/1.1/pngnq-1.1.tar.gz'
  homepage 'http://pngnq.sourceforge.net/'
  md5 'fdbb94d504931b50c54202b62f98aa44'

  depends_on 'pkg-config' => :build

  def install
    ENV.x11 # for libpng
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
