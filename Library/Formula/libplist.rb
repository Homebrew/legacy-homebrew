class Libplist < Formula
  desc "Library for Apple Binary- and XML-Property Lists"
  homepage "http://www.libimobiledevice.org"
  url "http://www.libimobiledevice.org/downloads/libplist-1.12.tar.bz2"
  sha256 "0effdedcb3de128c4930d8c03a3854c74c426c16728b8ab5f0a5b6bdc0b644be"

  bottle do
    cellar :any
    sha256 "44d4da500ed4448656ce335d43ff89c8df8bfc7fd7d78515e9e111e32673e645" => :el_capitan
    sha256 "c6f8dbc8fc0431d41e73c8f7da6a1292ec7d26358208540d99f775ad9af900ca" => :yosemite
    sha256 "5bfb26555e67a5a8b144ea187e32ba4b287901e4b7358e9b617aad2ddc82f9eb" => :mavericks
    sha256 "251e34405ba2111cb2f30e0857b81072b92563ebd9efa77e240214daf106560f" => :mountain_lion
  end

  head do
    url "http://git.sukimashita.com/libplist.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  option "with-python", "Enable Cython Python bindings"

  depends_on "pkg-config" => :build
  depends_on "libxml2"
  depends_on :python => :optional

  resource "cython" do
    url "http://cython.org/release/Cython-0.21.tar.gz"
    sha256 "0cd5787fb3f1eaf8326b21bdfcb90aabd3eca7c214c5b7b503fbb82da97bbaa0"
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
        system "python", "setup.py", "build", "install", "--prefix=#{buildpath}",
                 "--single-version-externally-managed", "--record=installed.txt"
      end
      ENV.prepend_path "PATH", "#{buildpath}/bin"
    else
      args << "--without-cython"
    end

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end
end
