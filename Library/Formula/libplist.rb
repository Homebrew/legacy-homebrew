require "formula"

class Libplist < Formula
  homepage "http://www.libimobiledevice.org"
  url "http://www.libimobiledevice.org/downloads/libplist-1.11.tar.bz2"
  sha1 "1a105757596131e3230382c21e06407090505427"

  head "http://git.sukimashita.com/libplist.git"

  option "with-python", "Enable Cython Python bindings"

  depends_on "pkg-config" => :build
  depends_on "libxml2"
  depends_on :python => :optional
  depends_on "Cython" => :python if build.with? "python"

  def install
    ENV.deparallelize
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
    ]
    args << "--without-cython" if build.without? "python"
    system "./configure", *args
    system "make install"
  end
end
