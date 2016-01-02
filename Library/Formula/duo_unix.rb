class DuoUnix < Formula
  desc "Two-factor authentication for SSH"
  homepage "https://www.duosecurity.com/docs/duounix"
  url "https://dl.duosecurity.com/duo_unix-1.9.17.tar.gz"
  sha256 "d841fb7cf48013d25c2abe882aa1888f230b8414b71ef5898ca988d000b5953a"

  bottle do
    cellar :any
    sha256 "49ce5dcbf9d025796dfe9cd5d7c1b8123c4418cdafab8bb3b910c5218b939e4f" => :el_capitan
    sha256 "055e5643825f5b581a6f57eb5f8a1b7cfcbf450f0e19201cf82a68c5545bfb04" => :yosemite
    sha256 "acbe2c050efc8127721e50879d00b56aa0ff2050f22facced4803d3671df11e7" => :mavericks
  end

  depends_on "openssl"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--includedir=#{include}/duo",
                          "--with-openssl=#{Formula["openssl"].opt_prefix}",
                          "--with-pam=#{lib}/pam/"
    system "make", "install"
  end

  test do
    system "#{sbin}/login_duo", "-d", "-c", "#{etc}/login_duo.conf",
                                "-f", "foobar", "echo", "SUCCESS"
  end
end
