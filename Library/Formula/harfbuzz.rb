require 'formula'

class Harfbuzz < Formula
  homepage 'http://www.freedesktop.org/wiki/Software/HarfBuzz'
  url 'http://www.freedesktop.org/software/harfbuzz/release/harfbuzz-0.9.28.tar.bz2'
  sha256 'a567f7c58018af0a9751e18641fd8434bfcef8307122dabe47dd652ce8bde048'

  bottle do
    cellar :any
    sha1 "77e8c83c64140d68ac8bbc4ec2673f4e6169034f" => :mavericks
    sha1 "6e002a4ccc3d53226b1a73252f6b4716f2cbf8e8" => :mountain_lion
    sha1 "f152cab6c0dd71ea9fa0b904c95792935cbbd76a" => :lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'cairo'
  depends_on 'icu4c' => :recommended
  depends_on 'freetype'

  def install
    args = %W[--disable-dependency-tracking --prefix=#{prefix}]
    args << "--with-icu" if build.with? 'icu4c'
    system "./configure", *args
    system "make install"
  end
end
