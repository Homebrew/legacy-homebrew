class Msmtp < Formula
  desc "SMTP client that can be used as an SMTP plugin for Mutt"
  homepage "http://msmtp.sourceforge.net"
  url "https://downloads.sourceforge.net/project/msmtp/msmtp/1.6.4/msmtp-1.6.4.tar.xz"
  sha256 "9b49c022a5440d41b6782c97ef2977d0346c3dae05aa8836243a9953e982d1cd"

  bottle do
    sha256 "6d1eef02a990fc1355f9d47da7237870d43ce0b5d24cb30a45c15952fdd815c4" => :el_capitan
    sha256 "d006ac74d71d76fb5c1881513c8204408c88863f38f37c5d2c1face8c7aeadfd" => :yosemite
    sha256 "a87c7d5ee59c48fdb1151cca93acea417db67f17cde2994ad97c2b0ee43722e3" => :mavericks
  end

  option "with-gsasl", "Use GNU SASL authentication library"

  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on "gsasl" => :optional

  def install
    args = %W[
      --disable-dependency-tracking
      --with-macosx-keyring
      --prefix=#{prefix}
      --with-tls=openssl
    ]

    args << "--with-libsasl" if build.with? "gsasl"

    system "./configure", *args
    system "make", "install"
    (share/"msmtp/scripts").install "scripts/msmtpq"
  end
end
