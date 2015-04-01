class Libewf < Formula
  homepage "https://github.com/libyal/libewf"
  url "https://googledrive.com/host/0B3fBvzttpiiSMTdoaVExWWNsRjg/libewf-20140608.tar.gz"
  sha256 "d14030ce6122727935fbd676d0876808da1e112721f3cb108564a4d9bf73da71"
  revision 1

  devel do
    url "https://github.com/libyal/libewf/releases/download/20150126/libewf-experimental-20150126.tar.gz"
    sha256 "adba8c45c32c41fccdcfc32ac4b20b9531a04a710f355165c23eaf6f2ec6700e"
  end

  bottle do
    cellar :any
    sha1 "3a5b2ae9cedd50aca714dacc91716b845922e9fe" => :yosemite
    sha1 "077829c293b2da99c076a6328e7e96837103fe6c" => :mavericks
    sha1 "b3d3877c1683b551badb8a21491faceb27958cf1" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end
