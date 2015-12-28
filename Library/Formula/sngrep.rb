class Sngrep < Formula
  desc "Command-line tool for displaying SIP calls message flows"
  homepage "https://github.com/irontec/sngrep"
  url "https://github.com/irontec/sngrep/archive/v1.2.0.tar.gz"
  sha256 "f7f9a05b4be9542ad0651d1deac3bb4cf40c9b1ebc40cfaa922d75a6997f1a7a"

  bottle do
    cellar :any
    sha256 "23b07b96e2aba627f3929c6d92ff9b1390e1a4fda71b56841d329c955b6d8407" => :yosemite
    sha256 "73b228cd5e6cf2d8d2114375d4399b0b6cc847d1c07e00a146706c99e4cc73bc" => :mavericks
    sha256 "d1527802672ba74c6aa5872fb6a9077b6b6f56f08f512f2de1678c317e0d39a3" => :mountain_lion
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
