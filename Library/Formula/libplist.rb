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

  resource "cython" do
    url "http://cython.org/release/Cython-0.20.2.tar.gz"
    sha1 "e3fd4c32bdfa4a388cce9538417237172c656d55"
  end

  def install
    ENV.deparallelize
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
    ]

    if build.with? "python"
      resource("cython").stage do
        ENV.prepend_create_path "PYTHONPATH", buildpath+"lib/python2.7/site-packages"
        system "python", "setup.py", "build", "install", "--prefix=#{buildpath}"
      end
      ENV.prepend_path "PATH", "#{buildpath}/bin"
    else
      args << "--without-cython"
    end

    system "./configure", *args
    system "make install"
  end
end
