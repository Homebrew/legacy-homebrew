require "formula"

class Sylpheed < Formula
  homepage "http://sylpheed.sraoss.jp/en/"
  url "http://sylpheed.sraoss.jp/sylpheed/v3.4/sylpheed-3.4.2.tar.gz"
  sha1 "693514a792f64ac1a138c7a6542d5ca6b7ac4fdc"

  bottle do
    sha1 "768d366c0eb0b8de1ad50ce405b05c20c5a6b2dc" => :yosemite
    sha1 "e105665502bd22ec0d66b63d65213dd282a20b7f" => :mavericks
    sha1 "fc773eb0a83d176922ff88daa58856c60420ea3a" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on :x11
  depends_on "gpgme"
  depends_on "gtk+"
  depends_on "cairo"
  depends_on "openssl"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-updatecheck"
    system "make", "install"
  end
end
