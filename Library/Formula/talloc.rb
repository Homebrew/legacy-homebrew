require "formula"

class Talloc < Formula
  homepage "http://talloc.samba.org/"
  url "http://www.samba.org/ftp/talloc/talloc-2.1.1.tar.gz"
  sha1 "380bb786274dfd1a4a8179d31cd88cbee15c97bf"

  conflicts_with "samba", :because => "both install `include/talloc.h`"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-rpath",
                          "--without-gettext",
                          "--disable-python"
    system "make install"
  end
end
