class Msmtp < Formula
  desc "SMTP client that can be used as an SMTP plugin for Mutt"
  homepage "http://msmtp.sourceforge.net"
  url "https://downloads.sourceforge.net/project/msmtp/msmtp/1.6.2/msmtp-1.6.2.tar.xz"
  sha256 "2f6ecd7cbfadf548fd55205bd24cb63b84bcbb1185efed917dd7800595a48789"

  bottle do
    sha256 "a74b5acfc2208061662c9dced09f6704b06f252317250d9d726cb309b85154e9" => :yosemite
    sha256 "4d31815b2eb044d87a7198bdd1c1188a6644ec37171714b663bd0c037cada714" => :mavericks
    sha256 "6e0b109c6d290ce71bc24302b0e4fd0a45a1f1b9db025afde8273e87e99777de" => :mountain_lion
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
