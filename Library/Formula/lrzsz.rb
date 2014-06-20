require 'formula'

class Lrzsz < Formula
  homepage 'http://www.ohse.de/uwe/software/lrzsz.html'
  url 'http://www.ohse.de/uwe/releases/lrzsz-0.12.20.tar.gz'
  sha1 '451e6a1813dfb71a412c973acd1b88b9ee3f28c4'

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"

    # there's a bug in lrzsz when using custom --prefix
    # must install the binaries manually first
    bin.install "src/lrz", "src/lsz"

    system "make install"

    bin.install_symlink "lrz" => "rz", "lsz" => "sz"
  end
end
