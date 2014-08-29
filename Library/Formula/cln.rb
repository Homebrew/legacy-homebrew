require "formula"

class Cln < Formula
  homepage "http://www.ginac.de/CLN/"
  url "http://www.ginac.de/CLN/cln-1.3.3.tar.bz2"
  sha1 "11c56780eb83ed54f2ad1ecef7f0dc0f609c426d"

  bottle do
    cellar :any
    sha1 "54f11e2ffe58d465e7ae7740a607f38169e99d32" => :mavericks
    sha1 "657f0060d774be90d2a88ebc480a20b6043e7c67" => :mountain_lion
    sha1 "3c4a67e6672596a0a9881fb23b7aa3c9eb2c673f" => :lion
  end

  depends_on "gmp"

  # Patch for Clang from MacPorts
  patch do
    url "https://trac.macports.org/export/114806/trunk/dports/math/cln/files/patch-clang.diff"
    sha1 "0e95e34b7b821fe8ddfc04c099cf5b9d72fc9093"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking"
    system "make install"
  end
end
