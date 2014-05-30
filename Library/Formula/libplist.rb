require "formula"

class Libplist < Formula
  homepage "http://www.libimobiledevice.org"
  url "http://www.libimobiledevice.org/downloads/libplist-1.11.tar.bz2"
  sha1 "1a105757596131e3230382c21e06407090505427"

  head "http://git.sukimashita.com/libplist.git"

  bottle do
    cellar :any
    sha1 "704dc72fd28c670551533f438ab642e80d269ce2" => :mavericks
    sha1 "0393087a627ed94d2755717360ad110aef1276f3" => :mountain_lion
    sha1 "b7e92b4a4b92e46fe9e57dcfdd382a558d04832f" => :lion
  end

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
