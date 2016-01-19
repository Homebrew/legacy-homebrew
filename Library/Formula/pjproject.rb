class Pjproject < Formula
  desc "C library for multimedia protocols such as SIP, SDP, RTP and more"
  homepage "http://www.pjsip.org/"
  url "http://www.pjsip.org/release/2.3/pjproject-2.3.tar.bz2"
  sha256 "e7fa60a3b59424430145af90372282ca778449f7b68b77bb24a9cf75d94d5765"

  bottle do
    cellar :any
    sha256 "3ee6735dd996f8963d0d47cdd0019fb144485b3e10b604589f99164abd757c10" => :yosemite
    sha256 "dae64c57018f78472c465c0f70883176d4edb5ceee27e93a8c1df448c8700fe8" => :mavericks
    sha256 "ebe8c9879332a77a90523f4791c70c109f57ffcecc176e77e2acdcb47bacaa3d" => :mountain_lion
  end

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
