class Sngrep < Formula
  desc "Command-line tool for displaying SIP calls message flows"
  homepage "https://github.com/irontec/sngrep"
  url "https://github.com/irontec/sngrep/archive/v0.2.2.tar.gz"
  sha256 "06e3478dfc1d85ba54dd3aabbfb61690ce85fde8cb8153f5ed871f4f5f31fb8f"

  bottle do
    cellar :any
    sha1 "2bc6823456c0c27280445367723632b82ae05c34" => :yosemite
    sha1 "f2ca4ac588eb6227cf038c7c9153cf37bd57e91a" => :mavericks
    sha1 "6d7830d3849f9428ce192dece2abe4dc4bc99784" => :mountain_lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "openssl"

  def install
    system "./bootstrap.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-openssl=#{Formula["openssl"].opt_prefix}"
    system "make", "install"
  end

  test do
    pipe_output "#{bin}/sngrep -I #{test_fixtures("test.pcap")}", "Q"
  end
end
