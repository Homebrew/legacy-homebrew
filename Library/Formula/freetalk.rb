require "formula"

class Freetalk < Formula
  homepage "http://www.gnu.org/software/freetalk"
  url "https://github.com/GNUFreetalk/freetalk/archive/v4.0rc5.tar.gz"
  version "4.0rc5"
  sha1 "ef506ab54847e55796835b82e6bfd5bce86d6994"

  head "https://github.com/GNUFreetalk/freetalk.git"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "guile"
  depends_on "glib"
  depends_on "loudmouth"
  depends_on "jansson"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "freetalk", "--version"
    system "freetalk", "--help"
  end
end
