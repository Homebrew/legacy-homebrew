class Libewf < Formula
  desc "Library for support of the Expert Witness Compression Format"
  homepage "https://github.com/libyal/libewf"
  url "https://googledrive.com/host/0B3fBvzttpiiSMTdoaVExWWNsRjg/libewf-20140608.tar.gz"
  sha256 "d14030ce6122727935fbd676d0876808da1e112721f3cb108564a4d9bf73da71"
  revision 1

  bottle do
    cellar :any
    sha1 "3a5b2ae9cedd50aca714dacc91716b845922e9fe" => :yosemite
    sha1 "077829c293b2da99c076a6328e7e96837103fe6c" => :mavericks
    sha1 "b3d3877c1683b551badb8a21491faceb27958cf1" => :mountain_lion
  end

  head do
    url "https://github.com/libyal/libewf.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"

  def install
    if build.head?
      system "./synclibs.sh"
      system "./autogen.sh"
    end
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ewfinfo -V")
  end
end
