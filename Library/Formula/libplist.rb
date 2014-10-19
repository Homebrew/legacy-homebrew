require "formula"

class Libplist < Formula
  homepage "http://www.libimobiledevice.org"
  url "http://www.libimobiledevice.org/downloads/libplist-1.11.tar.bz2"
  sha1 "1a105757596131e3230382c21e06407090505427"

  head "http://git.sukimashita.com/libplist.git"

  bottle do
    cellar :any
    revision 1
    sha1 "cdb47a2580cb22b91f5f7e54c4c931656d85c191" => :yosemite
    sha1 "0a09124d49ed3f662191fc4d11dcd9fa01530c8f" => :mavericks
    sha1 "60f6e063e274c92a220e4f926e4acec7c76c25be" => :mountain_lion
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
