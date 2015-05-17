class Ldns < Formula
  homepage "https://nlnetlabs.nl/projects/ldns/"
  url "https://nlnetlabs.nl/downloads/ldns/ldns-1.6.17.tar.gz"
  sha256 "8b88e059452118e8949a2752a55ce59bc71fa5bc414103e17f5b6b06f9bcc8cd"
  revision 1

  bottle do
    revision 3
    sha1 "29548cdff439f712695fc5ca9f662b958ce98765" => :mavericks
    sha1 "e55a981bf3a3ce87f914043c36c6c1eb0a0d9b38" => :mountain_lion
    sha1 "ba53827d4834ae71cb66c437f16e631cde014cff" => :lion
  end

  depends_on :python => :optional
  depends_on "openssl"
  depends_on "swig" => :build if build.with? "python"

  def install
    args = %W[
      --prefix=#{prefix}
      --with-drill
      --with-examples
      --with-ssl=#{Formula["openssl"].opt_prefix}
    ]

    args << "--with-pyldns" if build.with? "python"

    system "./configure", *args
    system "make"
    system "make", "install"
    system "make", "install-pyldns" if build.with? "python"
    (lib/"pkgconfig").install "packaging/libldns.pc"
  end

  test do
    (testpath/"powerdns.com.dnskey").write("powerdns.com.   10773 IN  DNSKEY  256 3 8 AwEAAbQOlJUPNWM8DQown5y/wFgDVt7jskfEQcd4pbLV/1osuBfBNDZX v9ru7wDC/PbpvysEZgFXTPJ9QrdwSsd8KAZVO5mjeDNL0RnlhjHWuXKC qnLI+iLb3OMLQTizjdscdHPoW98wk5931pJkyf2qMDRjRB4c5d81sfoZ Od6D7Rrx\npowerdns.com.   10773 IN  DNSKEY  257 3 8 AwEAAb/+pXOZWYQ8mv9WM5dFva8WU9jcIUdDuEjldbyfnkQ/xlrJC5zA EfhYhrea3SmIPmMTDimLqbh3/4SMTNPTUF+9+U1vpNfIRTFadqsmuU9F ddz3JqCcYwEpWbReg6DJOeyu+9oBoIQkPxFyLtIXEPGlQzrynKubn04C x83I6NfzDTraJT3jLHKeW5PVc1ifqKzHz5TXdHHTA7NkJAa0sPcZCoNE 1LpnJI/wcUpRUiuQhoLFeT1E432GuPuZ7y+agElGj0NnBxEgnHrhrnZW UbULpRa/il+Cr5Taj988HqX9Xdm6FjcP4Lbuds/44U7U8du224Q8jTrZ 57Yvj4VDQKc=")
    system "#{bin}/ldns-key2ds", "powerdns.com.dnskey"
    assert_match /d4c3d5552b8679faeebc317e5f048b614b2e5f607dc57f1553182d49ab2179f7/, File.read("Kpowerdns.com.+008+44030.ds")
  end
end
