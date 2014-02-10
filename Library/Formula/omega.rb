require "formula"

class Omega < Formula
  homepage "http://xapian.org"
  url "http://oligarchy.co.uk/xapian/1.2.17/xapian-omega-1.2.17.tar.xz"
  sha1 "245fb742042ff15d234dd68b1372837c4d5993ba"

  depends_on 'pcre'
  depends_on 'xapian'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

end
