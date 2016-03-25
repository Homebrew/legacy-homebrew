class Darkstat < Formula
  desc "Network traffic analyzer"
  homepage "https://unix4lyfe.org/darkstat/"
  url "https://unix4lyfe.org/darkstat/darkstat-3.0.719.tar.bz2"
  sha256 "aeaf909585f7f43dc032a75328fdb62114e58405b06a92a13c0d3653236dedd7"

  bottle do
    cellar :any_skip_relocation
    sha256 "8cfff973e95ff4c31248690df0ae28e05ddbef97f926ed4f075b919274c59116" => :el_capitan
    sha256 "290629ecfb0a650104bd6560bb352af9b54e2d0c1e1e0de0d7113dab13167133" => :yosemite
    sha256 "c613e70eb9f84aa7acaef6f1791495762537ab0fe12368ddec009a66fb91d3f8" => :mavericks
    sha256 "fba985f30c240602c9b5ebccda87fcea7c52caba69c4c8cc5375e090a773ce19" => :mountain_lion
  end

  head do
    url "https://www.unix4lyfe.org/git/darkstat", :using => :git
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  def install
    system "autoreconf", "-iv" if build.head?
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system sbin/"darkstat", "--verbose", "-r", test_fixtures("test.pcap")
  end
end
