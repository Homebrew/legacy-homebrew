require 'formula'

class Harfbuzz < Formula
  homepage 'http://www.freedesktop.org/wiki/Software/HarfBuzz'
  url 'http://www.freedesktop.org/software/harfbuzz/release/harfbuzz-0.9.27.tar.bz2'
  sha256 '08584ae91c98d5b14d5f2c45b01410a12b030c9397bd73135bd2155297b447db'

  bottle do
    cellar :any
    sha1 "27623054bf6ca9f54428f0fe63bc2c2caa726325" => :mavericks
    sha1 "120db14c8928fc948340ff14ecab0bb814048fac" => :mountain_lion
    sha1 "7c99b0595e9ea6e44eb346779bd06db1aeb6b49a" => :lion
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
