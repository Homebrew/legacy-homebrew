class Bashdb < Formula
  desc "Bash shell debugger"
  homepage "http://bashdb.sourceforge.net"
  url "https://downloads.sourceforge.net/project/bashdb/bashdb/4.3-0.91/bashdb-4.3-0.91.tar.bz2"
  version "4.3-0.91"
  sha256 "60117745813f29070a034c590c9d70153cc47f47024ae54bfecdc8cd86d9e3ea"

  depends_on "bash"
  depends_on :macos => :mountain_lion

  def install
    system "./configure", "--with-bash=#{HOMEBREW_PREFIX}/bin/bash",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    system "#{bin}/bashdb", "--version"
  end
end
