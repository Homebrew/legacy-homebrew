class DuoUnix < Formula
  desc "Two-factor authentication for SSH"
  homepage "https://www.duosecurity.com/docs/duounix"
  url "https://dl.duosecurity.com/duo_unix-1.9.16.tar.gz"
  sha256 "66a109723f5de0ad524a4ceb35e8a540d9fbbcecc9984be27ec91466cedd193b"

  bottle do
    cellar :any
    sha256 "3d2c111c427dbe2cdd824216b20e25831b5e5fa89fb583cb5376d55928f9995e" => :el_capitan
    sha256 "5d8ce90613f03d5b6e4ac71450dffc35213f6aeaec36484e18db915514544300" => :yosemite
    sha256 "10c5899dfe1493b604545c52c2bfb4d90deaa3007a753b7469701a4f8d0357ae" => :mavericks
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
