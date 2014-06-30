require 'formula'

class Libass < Formula
  homepage 'https://github.com/libass/libass'
  url 'https://github.com/libass/libass/releases/download/0.11.2/libass-0.11.2.tar.gz'
  sha1 'cd9df9000b5a303be56b66fef7497a8ff60ad844'

  depends_on 'pkg-config' => :build
  depends_on 'yasm' => :build

  depends_on 'freetype'
  depends_on 'fribidi'
  depends_on 'fontconfig'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
