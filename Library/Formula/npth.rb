require 'formula'

class Npth < Formula
  homepage 'http://lwn.net/Articles/496268/'
  url 'ftp://ftp.gnupg.org/gcrypt/npth/npth-0.91.tar.bz2'
  sha1 'bb10db9f043fb63424162b6da6969af9082e6fa0'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
