class Stunnel < Formula
  desc "SSL tunneling program"
  homepage "https://www.stunnel.org/"
  url "https://www.stunnel.org/downloads/stunnel-5.23.tar.gz"
  mirror "https://www.usenix.org.uk/mirrors/stunnel/stunnel-5.23.tar.gz"
  sha256 "0fc4a702afd2e857bae8ad1f39c51546eb282c3d0ff4f4d55d62aece7328ddea"

  bottle do
    sha256 "a7c7556a6c17c2b5b131dcc8e5a66e3d7a7fdd5690bab34a009f359ffe59b9a2" => :el_capitan
    sha256 "754cd51e26be1d898e0bfe861baef5eae6ad20c735f5b32356c0c95467b90dd0" => :yosemite
    sha256 "fc4267fd40c4cae2f08283dd126a8c4daee78405b7574f196771fe0acfbcfccd" => :mavericks
    sha256 "44c0bdbc5102a1259d4f4617d5a2c8b5c1043a0d4e32c2a1fc4767b09674c5cb" => :mountain_lion
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

    assert_match /successful/, pipe_output("#{bin}/stunnel #{testpath}/tstunnel.conf 2>&1")
  end
end
