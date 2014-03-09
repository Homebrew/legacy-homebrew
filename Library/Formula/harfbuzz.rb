require 'formula'

class Harfbuzz < Formula
  homepage 'http://www.freedesktop.org/wiki/Software/HarfBuzz'
  url 'http://www.freedesktop.org/software/harfbuzz/release/harfbuzz-0.9.26.tar.bz2'
  sha256 '5ded7dc3d15fb5c9230d7a224b9256b67b35fde30193b4c3a4c3f6b13110e257'

  bottle do
    cellar :any
    sha1 "f070bb22af0d70c2f6d23ed192814b3358f45ac6" => :mavericks
    sha1 "17ade866edc8b1231f88cfee067f588c17f013db" => :mountain_lion
    sha1 "1a0cd3cde6b86554a04d9f6fef0d79d0459ff30b" => :lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'cairo'
  depends_on 'icu4c' => :recommended
  depends_on :freetype

  def install
    args = %W[--disable-dependency-tracking --prefix=#{prefix}]
    args << "--with-icu" if build.with? 'icu4c'
    system "./configure", *args
    system "make install"
  end
end
