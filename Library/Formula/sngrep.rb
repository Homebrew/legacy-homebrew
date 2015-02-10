class Sngrep < Formula
  homepage "https://github.com/irontec/sngrep"
  url "https://github.com/irontec/sngrep/archive/v0.2.2.tar.gz"
  sha1 "6d492ba418eafec563ff756dd6d612722c535676"

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
