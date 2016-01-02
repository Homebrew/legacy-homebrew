class Tinc < Formula
  desc "Virtual Private Network (VPN) tool"
  homepage "http://www.tinc-vpn.org"
  url "http://tinc-vpn.org/packages/tinc-1.0.26.tar.gz"
  sha256 "2b4319ddb3bd2867e72532a233f640a58c2f4d83f1088183ae544b268646ba21"

  bottle do
    sha256 "028353499ec60475476a59643463ab35cbd562c352b00ed6700b7e9ba8748a15" => :el_capitan
    sha256 "2985e4a5eb9784448887857ed7ae3a7dc0ef9df4505d3592dec865f6f9bbaed0" => :yosemite
    sha256 "0313b51953e300bf60c87722c8432c902c20d6b0fc484a03dc5796e3bbb87b6b" => :mavericks
  end

  devel do
    url "http://www.tinc-vpn.org/packages/tinc-1.1pre11.tar.gz"
    sha256 "942594563d3aef926a2d04e9ece90c16daf1c700e99e3b91ff749e8377fbf757"
  end

  depends_on "lzo"
  depends_on "openssl"

  def install
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}",
                          "--with-openssl=#{Formula["openssl"].opt_prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}/tincd --version")
  end
end
