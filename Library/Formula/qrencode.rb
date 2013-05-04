require 'formula'

class Qrencode < Formula
  homepage 'http://fukuchi.org/works/qrencode/index.html.en'
  url 'http://fukuchi.org/works/qrencode/qrencode-3.4.2.tar.gz'
  sha1 '7daaad61f333ff6cdabfb0d925c3ab668d16dee2'

  depends_on 'pkg-config' => :build
  depends_on :libpng

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
