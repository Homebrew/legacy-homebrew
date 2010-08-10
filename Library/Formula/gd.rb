require 'formula'

class Gd <Formula
  url "http://www.libgd.org/releases/gd-2.0.36RC1.tar.gz"
  homepage "http://www.libgd.org"
  md5 "39ac48e6d5e0012a3bd2248a0102f209"

  depends_on 'jpeg' => :recommended

  def install
    ENV.libpng
    system "./configure", "--prefix=#{prefix}", "--with-freetype=/usr/X11"
    system "make install"
  end
end
