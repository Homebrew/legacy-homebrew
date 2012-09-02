require 'formula'

class Sl < Formula
  homepage 'http://packages.debian.org/source/stable/sl'
  url 'http://mirrors.kernel.org/debian/pool/main/s/sl/sl_3.03.orig.tar.gz'
  mirror 'http://ftp.us.debian.org/debian/pool/main/s/sl/sl_3.03.orig.tar.gz'
  sha1 'd0a8e52ef649cd3bbf02c099e9991dc7cb9b60c3'

  fails_with :clang do
    build 318
  end

  def install
    system "make -e"
    bin.install "sl"
    man1.install "sl.1"
  end
end
