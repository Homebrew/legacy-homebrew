require 'formula'

class Qrencode < Formula
  homepage 'http://fukuchi.org/works/qrencode/index.html.en'
  url 'http://fukuchi.org/works/qrencode/qrencode-3.3.1.tar.gz'
  sha1 'a5a99f47f4215ec17e74999fdb893a4e542f790c'

  depends_on 'pkg-config' => :build
  depends_on :libpng

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
