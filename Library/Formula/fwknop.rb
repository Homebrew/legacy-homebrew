require "formula"

class Fwknop < Formula
  homepage "http://www.cipherdyne.org/fwknop/"
  head "https://github.com/mrash/fwknop.git"
  url "https://github.com/mrash/fwknop/archive/2.6.4.tar.gz"
  sha1 "b13ef022ade7da6dc5b08335d5a1d29dd898887b"

  bottle do
    sha1 "a8f0c47a80109c15bbdbee4c6b768a5970d87786" => :mavericks
    sha1 "28c45793806d7cdd6bdce5001a44645ce3c258b8" => :mountain_lion
    sha1 "c963e977da7c1171b56b9e5dce523b7ddbc42b35" => :lion
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build
  depends_on "gpgme"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-gpgme"
    system "make install"
  end

  test do
    system "#{bin}/fwknop", "--version"
  end
end
