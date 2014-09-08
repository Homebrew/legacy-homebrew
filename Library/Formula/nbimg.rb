require 'formula'

class Nbimg < Formula
  homepage 'https://github.com/poliva/nbimg'
  url 'https://github.com/poliva/nbimg/archive/v1.2.1.tar.gz'
  sha1 '21a12e2451eefb5296e682744614b3f46e1f427a'

  def install
    inreplace 'Makefile', 'all: nbimg win32', 'all: nbimg'
    system "make", "prefix=#{prefix}",
                   "bindir=#{bin}",
                   "docdir=#{doc}",
                   "mandir=#{man}",
                   "install"
  end

  test do
    curl "https://gist.githubusercontent.com/staticfloat/8253400/raw/41aa4aca5f1aa0a82c85c126967677f830fe98ee/tiny.bmp", "-O"
    system "#{bin}/nbimg", "-Ftiny.bmp"
  end
end
