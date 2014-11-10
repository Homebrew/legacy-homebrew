require "formula"

class Libplist < Formula
  homepage "http://www.libimobiledevice.org"
  url "http://www.libimobiledevice.org/downloads/libplist-1.12.tar.bz2"
  sha1 "48f071c723387637ef2cc2980d4ca0627aab067b"

  bottle do
    cellar :any
    sha1 "cdb47a2580cb22b91f5f7e54c4c931656d85c191" => :yosemite
    sha1 "0a09124d49ed3f662191fc4d11dcd9fa01530c8f" => :mavericks
    sha1 "60f6e063e274c92a220e4f926e4acec7c76c25be" => :mountain_lion
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
    sha1 "f5784539870715e33b51374e9c4451ff6ff21c7f"
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
