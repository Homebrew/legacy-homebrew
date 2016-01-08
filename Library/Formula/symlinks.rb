class Symlinks < Formula
  desc "scan/change symbolic links"
  homepage "http://www.ibiblio.org/pub/Linux/utils/file/symlinks.lsm"
  url "http://www.ibiblio.org/pub/Linux/utils/file/symlinks-1.4.tar.gz"
  sha256 "b0bb689dd0a2c46d9a7dd111b053707aba7b9cf29c4f0bad32984b14bdbe0399"

  def install
    inreplace "Makefile", "/usr/local/bin", "#{bin}/"
    inreplace "Makefile", "/usr/local/man/man8", "#{man8}/"
    inreplace "Makefile", "-o root -g root", ""

    mkdir_p "#{bin}"
    mkdir_p "#{man8}"

    ENV["CFLAGS"]="-I/usr/include/malloc"
    system "make", "CFLAGS=#{ENV.cflags}"
    system "make", "install"
  end

  test do
    system "#{bin}/symlinks", "."
  end
end
