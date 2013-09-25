require 'formula'

class Le < Formula
  homepage 'http://freecode.com/projects/leeditor'
  url 'http://ftp.yar.ru/pub/source/le/le-1.14.9.tar.xz'
  sha1 '1ee2cf4a236a8a429bb20040dda172c7f985916e'

  depends_on 'xz' => :build

  def install
    ENV.j1
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
