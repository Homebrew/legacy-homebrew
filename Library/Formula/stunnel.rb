class Stunnel < Formula
  desc "SSL tunneling program"
  homepage "https://www.stunnel.org/"
  url "https://www.stunnel.org/downloads/stunnel-5.23.tar.gz"
  mirror "https://www.usenix.org.uk/mirrors/stunnel/stunnel-5.23.tar.gz"
  sha256 "0fc4a702afd2e857bae8ad1f39c51546eb282c3d0ff4f4d55d62aece7328ddea"

  bottle do
    sha256 "be4ee6b09e1d397537d21fd2e453ce95b82b533484653174a3b113d88e520b85" => :yosemite
    sha256 "e5279aa80436f63cc7a921e222100b8834e56cc5f19f592354ac125770c7379b" => :mavericks
    sha256 "af4e77c71b62378eed6ab447346522b7953034aae7dd4bbce2033b29ed8d3bad" => :mountain_lion
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
