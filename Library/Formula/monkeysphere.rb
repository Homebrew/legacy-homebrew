class Monkeysphere < Formula
  desc "Use the OpenPGP web of trust to verify ssh connections"
  homepage "http://web.monkeysphere.info/"
  url "http://archive.monkeysphere.info/debian/pool/monkeysphere/m/monkeysphere/monkeysphere_0.37.orig.tar.gz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/m/monkeysphere/monkeysphere_0.37.orig.tar.gz"
  sha256 "b510b8a414fb400356e80f1f882488785df72ac54078410b54d4c50a84686e59"

  head "git://git.monkeysphere.info/monkeysphere"

  depends_on "gnu-sed" => :build
  depends_on "openssl"

  resource "Crypt::OpenSSL::Bignum" do
    url "https://cpan.metacpan.org/authors/id/K/KM/KMX/Crypt-OpenSSL-Bignum-0.06.tar.gz"
    sha256 "c7ccafa9108524b9a6f63bf4ac3377f9d7e978fee7b83c430af7e74c5fcbdf17"
  end

  def install
    ENV.prepend_path "PATH", Formula["gnu-sed"].libexec/"gnubin"
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    resource("Crypt::OpenSSL::Bignum").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make", "install"
    end

    ENV["PREFIX"] = prefix
    ENV["ETCPREFIX"] = prefix
    system "make", "install"

    # This software expects to be installed in a very specific, unusual way.
    # Consequently, this is a bit of a naughty hack but the least worst option.
    inreplace pkgshare/"keytrans", "#!/usr/bin/perl -T",
                                   "#!/usr/bin/perl -T -I#{libexec}/lib/perl5"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/monkeysphere v")
    # This just checks it finds the vendored Perl resource.
    assert_match "We need at least", pipe_output("#{bin}/openpgp2pem --help 2>&1")
  end
end
