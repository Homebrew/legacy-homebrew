require 'formula'

class Npth < Formula
  homepage 'http://lwn.net/Articles/496268/'
  url 'ftp://ftp.gnupg.org/gcrypt/npth/npth-0.91.tar.bz2'
  sha1 'bb10db9f043fb63424162b6da6969af9082e6fa0'

  bottle do
    cellar :any
    sha1 "6830f2d744b23859fa690454d02a2c60a8ae73c4" => :mavericks
    sha1 "9ea753df5be9e97514f67ebe5969146064648f23" => :mountain_lion
    sha1 "931d244c23b907c732286cfa5099e03978506ce5" => :lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
