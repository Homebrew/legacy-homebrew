require "formula"

class Cln < Formula
  homepage "http://www.ginac.de/CLN/"
  url "http://www.ginac.de/CLN/cln-1.3.4.tar.bz2"
  sha1 "76f73071236ead72ba5c9ee892f29ca24e557b8c"

  bottle do
    cellar :any
    sha1 "54f11e2ffe58d465e7ae7740a607f38169e99d32" => :mavericks
    sha1 "657f0060d774be90d2a88ebc480a20b6043e7c67" => :mountain_lion
    sha1 "3c4a67e6672596a0a9881fb23b7aa3c9eb2c673f" => :lion
  end

  depends_on "gmp"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking"
    system "make install"
  end
end
