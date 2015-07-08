require "formula"

class Bashdb < Formula
  desc "Bash shell debugger"
  homepage "http://bashdb.sourceforge.net"
  url "https://downloads.sourceforge.net/project/bashdb/bashdb/4.3-0.91/bashdb-4.3-0.91.tar.bz2"
  sha1 "e84841e51ebf6b1727d31c94722ef55c6b0a26af"
  version "4.3-0.91"

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
