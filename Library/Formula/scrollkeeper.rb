class Scrollkeeper < Formula
  desc "Transitional package for scrollkeeper"
  homepage "http://scrollkeeper.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/scrollkeeper/scrollkeeper/0.3.14/scrollkeeper-0.3.14.tar.gz"
  sha256 "4a0bd3c3a2c5eca6caf2133a504036665485d3d729a16fc60e013e1b58e7ddad"

  depends_on "gettext"
  depends_on "docbook"

  conflicts_with "rarian",
    :because => "scrollkeeper and rarian install the same binaries."

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-xml-catalog=#{etc}/xml/catalog"
    system "make"
    system "make", "install"
  end
end
