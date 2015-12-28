class Sngrep < Formula
  desc "Command-line tool for displaying SIP calls message flows"
  homepage "https://github.com/irontec/sngrep"
  url "https://github.com/irontec/sngrep/archive/v1.2.0.tar.gz"
  sha256 "f7f9a05b4be9542ad0651d1deac3bb4cf40c9b1ebc40cfaa922d75a6997f1a7a"

  bottle do
    cellar :any_skip_relocation
    sha256 "86d7cdf06db7e971539120b69bf94e6e21af83a31b15662484ba6dafb32d0aba" => :el_capitan
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
