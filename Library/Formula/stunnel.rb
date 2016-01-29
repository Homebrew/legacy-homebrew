class Stunnel < Formula
  desc "SSL tunneling program"
  homepage "https://www.stunnel.org/"
  url "https://www.stunnel.org/downloads/stunnel-5.30.tar.gz"
  mirror "https://www.usenix.org.uk/mirrors/stunnel/stunnel-5.30.tar.gz"
  sha256 "7d6eb389f6a1954b3bcf6c71d4ae3c5f9dde1990dd0b9e0cb1c7caf138d60570"

  bottle do
    sha256 "45bc99086d5075493a394c0e55fdb00f1eadf0b1b49309b1ee5b306283d0b707" => :el_capitan
    sha256 "c4e238ede346de33663c440d704406b30c90f8155bbec36ec11c51e50d05d2b4" => :yosemite
    sha256 "51ee9cabca8fbaa1f131673cd6acb6e68fcacf71df793530c655c7e385ca2db5" => :mavericks
  end

  # Please revision me whenever OpenSSL is updated
  # "Update OpenSSL shared libraries or rebuild stunnel"
  depends_on "openssl"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          "--mandir=#{man}",
                          "--disable-libwrap",
                          "--disable-systemd",
                          "--with-ssl=#{Formula["openssl"].opt_prefix}"
    system "make", "install"

    # This programmatically recreates pem creation used in the tools Makefile
    # which would usually require interactivity to resolve.
    cd "tools" do
      args = %w[req -new -x509 -days 365 -rand stunnel.rnd -config
                openssl.cnf -out stunnel.pem -keyout stunnel.pem -sha256 -subj
                /C=PL/ST=Mazovia\ Province/L=Warsaw/O=Stunnel\ Developers/OU=Provisional\ CA/CN=localhost/]
      system "dd", "if=/dev/urandom", "of=stunnel.rnd", "bs=256", "count=1"
      system "#{Formula["openssl"].opt_bin}/openssl", *args
      chmod 0600, "stunnel.pem"
      (etc/"stunnel").install "stunnel.pem"
    end
  end

  def caveats
    <<-EOS.undent
      A bogus SSL server certificate has been installed to:
        #{etc}/stunnel/stunnel.pem

      This certificate will be used by default unless a config file says otherwise!
      Stunnel will refuse to load the sample configuration file if left unedited.

      In your stunnel configuration, specify a SSL certificate with
      the "cert =" option for each service.
    EOS
  end

  test do
    (testpath/"tstunnel.conf").write <<-EOS.undent
      cert = #{etc}/stunnel/stunnel.pem

      setuid = nobody
      setgid = nobody

      [pop3s]
      accept  = 995
      connect = 110

      [imaps]
      accept  = 993
      connect = 143
    EOS

    assert_match "successful", pipe_output("#{bin}/stunnel #{testpath}/tstunnel.conf 2>&1")
  end
end
