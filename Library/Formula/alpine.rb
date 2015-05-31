class Alpine < Formula
  homepage "http://patches.freeiz.com/alpine/"
  url "http://patches.freeiz.com/alpine/release/src/alpine-2.20.tar.xz"
  sha256 "ed639b6e5bb97e6b0645c85262ca6a784316195d461ce8d8411999bf80449227"

  bottle do
    sha1 "51fb44fd30777e0a64924689978e4f2d795176a5" => :yosemite
    sha1 "70ff0f3bf57301618a5e62eee32949626fe944e0" => :mavericks
    sha1 "bf5133161a796b895e07d0637ea4beae5457a96c" => :mountain_lion
  end

  depends_on "openssl"

  def install
    ENV.j1
    system "./configure", "--disable-debug",
                          "--with-ssl-dir=#{Formula["openssl"].opt_prefix}",
                          "--with-ssl-certs-dir=#{etc}/openssl",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/alpine", "-supported"
  end
end
