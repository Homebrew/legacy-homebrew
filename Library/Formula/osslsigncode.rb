require "formula"

class Osslsigncode < Formula
  homepage "http://sourceforge.net/projects/osslsigncode/"
  url "https://downloads.sourceforge.net/project/osslsigncode/osslsigncode/osslsigncode-1.6.tar.gz"
  sha1 "83c169638c8c1e0122127674cbb73d2e0e6b5bc2"
  revision 1

  bottle do
    cellar :any
    sha1 "0f6af448002b345962fc41199ade20fb16b74891" => :mavericks
    sha1 "bbf54f6cb1f2be5a82628e6b34af03f9b9311237" => :mountain_lion
    sha1 "53019dd5187a15410279c583c2445a38bfe219ba" => :lion
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on "libgsf" => :optional

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
