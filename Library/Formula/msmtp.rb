class Msmtp < Formula
  homepage "http://msmtp.sourceforge.net"
  url "https://downloads.sourceforge.net/project/msmtp/msmtp/1.6.1/msmtp-1.6.1.tar.xz"
  sha1 "ac70151bcb53af5e192cbb147fd2b8139c637089"

  bottle do
    sha1 "fdc446edaff06269af325e4b95c10788d187b79e" => :yosemite
    sha1 "cdb0533ee36dbcb9fe249adbc74f0394a605fa78" => :mavericks
    sha1 "dc7336d5b49a22dc7b014529d08c6c98b7ad0c9f" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"

  def install
    args = %W[
      --disable-dependency-tracking
      --with-macosx-keyring
      --prefix=#{prefix}
      --with-tls=openssl
    ]

    system "./configure", *args
    system "make", "install"
    (share/"msmtp/scripts").install "scripts/msmtpq"
  end
end
