require 'formula'

class Mpir < Formula
  homepage 'http://www.mpir.org/'
  url 'http://www.mpir.org/mpir-2.6.0.tar.bz2'
  sha1 '28a91eb4d2315a9a73dc39771acf2b99838b9d72'

  fails_with :clang do
    build 425
    cause <<-EOS.undent
      Configure message:
      checking compiler cc -O2 -fomit-frame-pointer ... no, gcc-4.3.2 on 64bit is bad,
      try -O1 or -fno-strict-aliasing for the flags.
    EOS
  end

  def install
    ENV.deparallelize

    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
