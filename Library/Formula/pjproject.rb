class Pjproject < Formula
  homepage "http://www.pjsip.org/"
  url "http://www.pjsip.org/release/2.3/pjproject-2.3.tar.bz2"
  sha256 "e7fa60a3b59424430145af90372282ca778449f7b68b77bb24a9cf75d94d5765"

  depends_on "openssl"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "dep"
    system "make"
    system "make", "install"
    bin.install "pjsip-apps/bin/pjsua-#{`uname -m`.chomp}-apple-darwin#{`uname -r`.chomp}" => "pjsua"
  end

  test do
    system "#{bin}/pjsua", "--version"
  end
end
