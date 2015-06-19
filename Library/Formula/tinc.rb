class Tinc < Formula
  desc "Virtual Private Network (VPN) tool"
  homepage "http://www.tinc-vpn.org"
  url "http://tinc-vpn.org/packages/tinc-1.0.25.tar.gz"
  sha1 "b728e1ed02862aab04b2a53a62c2f67edd0c3949"

  bottle do
    sha1 "359656333342ffc8fa80ca09a89390833816b163" => :yosemite
    sha1 "c70ebe54e832e8e920a74e92764306439d9811a4" => :mavericks
    sha1 "762f671f4ec7065728fdd9450e8a363a2db24601" => :mountain_lion
  end

  devel do
    url "http://www.tinc-vpn.org/packages/tinc-1.1pre11.tar.gz"
    sha1 "ee6920d87b377c39da71d7ad5807a37f55e4e3be"
  end

  depends_on "lzo"
  depends_on "openssl"

  def install
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}",
                          "--with-openssl=#{Formula["openssl"].opt_prefix}"
    system "make", "install"
  end

  test do
    assert_match /^tinc version [-0-9a-z.]/, `#{sbin}/tincd --version`
  end
end
