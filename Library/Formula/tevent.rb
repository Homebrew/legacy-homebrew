require "formula"

class Tevent < Formula
  homepage "http://tevent.samba.org/"
  url "http://www.samba.org/ftp/tevent/tevent-0.9.21.tar.gz"
  sha1 "daa1a4f457773be2e0f645beede93db6943224a5"

  depends_on "pkg-config" => :build
  depends_on "talloc"

  conflicts_with "samba", :because => "both install `include/tevent.h`"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-rpath",
                          "--without-gettext",
                          "--bundled-libraries=!talloc"
    system "make install"
  end
end
