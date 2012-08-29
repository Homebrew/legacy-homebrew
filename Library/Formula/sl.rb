require 'formula'

class Sl < Formula
  homepage 'http://packages.debian.org/source/stable/sl'
  url 'http://mirrors.kernel.org/debian/pool/main/s/sl/sl_3.03.orig.tar.gz'
  mirror 'http://ftp.us.debian.org/debian/pool/main/s/sl/sl_3.03.orig.tar.gz'
  md5 'd0d997b964bb3478f7f4968eee13c698'

  fails_with :clang do
    build 318
  end

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install "sl"
    man1.install "sl.1"
  end
end
