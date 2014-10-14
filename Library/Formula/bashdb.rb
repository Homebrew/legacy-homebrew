require "formula"

class Bashdb < Formula
  homepage "http://bashdb.sourceforge.net"
  url "https://downloads.sourceforge.net/project/bashdb/bashdb/4.3-0.9/bashdb-4.3-0.9.tar.bz2"
  sha1 "0eed12b3d0c23e75feb97ef885a60cb81cc997a3"
  version "4.3-0.9"

  depends_on "bash"
  depends_on :macos => :mountain_lion

  def install
    system "./configure", "--with-bash=#{HOMEBREW_PREFIX}/bin/bash",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    system "make install"
  end

  test do
    system "#{bin}/bashdb", "--version"
  end
end
