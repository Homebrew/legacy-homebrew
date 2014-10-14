require 'formula'

class Bison < Formula
  homepage 'http://www.gnu.org/software/bison/'
  url 'http://ftpmirror.gnu.org/bison/bison-3.0.2.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/bison/bison-3.0.2.tar.gz'
  sha1 '4bbb9a1bdc7e4328eb4e6ef2479b3fe15cc49e54'

  bottle do
    sha1 "11f06b582581bd6be34717b696dd5d414fdca977" => :mavericks
    sha1 "7d5d9b155a773da9a9a95189c8a7e66607901fee" => :mountain_lion
    sha1 "cac23ffc39526cfd0ca9d47b89ab0d32122f2a52" => :lion
  end

  keg_only :provided_by_osx, 'Some formulae require a newer version of bison.'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
