require "formula"

class Eet < Formula
  homepage "http://trac.enlightenment.org/e/wiki/Eet"
  url "http://download.enlightenment.org/releases/eet-1.7.10.tar.gz"
  sha1 "7cf6938cc76fbf1cd8e2721606d61c93c09edd9e"

  bottle do
    cellar :any
    sha1 "73d9599c2ab8fa5067ff4fc4fddacbeb19b825c4" => :yosemite
    sha1 "36315f8d5bc59d56c6082e76e8dd2a9bfaec3735" => :mavericks
    sha1 "dcc57b32e7225fe86c83a5bfaade296d828b9ba0" => :mountain_lion
  end

  head do
    url "http://svn.enlightenment.org/svn/e/trunk/eet/"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "eina"
  depends_on "jpeg"
  depends_on "lzlib"
  depends_on "openssl"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
