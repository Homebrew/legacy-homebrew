require 'formula'

class Pseudo < Formula
  homepage 'https://github.com/sstephenson/pseudo'
  url 'https://github.com/sstephenson/pseudo/archive/v1.0.0.tar.gz'
  sha1 '0655af6e695078f45062e535a5aa69c8a8d2663e'

  head 'https://github.com/sstephenson/pseudo.git'

  def install
    bin.mkpath
    man1.mkpath

    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/pseudo", "--version"
  end
end
