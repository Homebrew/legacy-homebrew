require 'formula'

class Outguess < Formula
  homepage 'http://www.outguess.org/'
  url 'http://www.outguess.org/outguess-0.2.tar.gz'
  mirror 'http://www.mirrors.wiretapped.net/security/steganography/outguess/outguess-0.2.tar.gz'
  md5 '321f23dc0badaba4350fa66b59829064'

  def install

    opoo "Formula has problem with clang during runtime, using llvm-gcc"
    ENV.gcc :force => true

    args = ["--disable-debug",
            "--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--sysconfdir=#{etc}",
            "--mandir=#{man}"
            ]

    system "./configure", *args
    system "make"

    bin.install "outguess"
    man1.install "outguess.1"
  end
end
