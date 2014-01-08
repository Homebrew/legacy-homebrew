require 'formula'

class Findutils < Formula
  homepage 'http://www.gnu.org/software/findutils/'
  url 'http://ftpmirror.gnu.org/findutils/findutils-4.4.2.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/findutils/findutils-4.4.2.tar.gz'
  sha1 'e8dd88fa2cc58abffd0bfc1eddab9020231bb024'

  option 'default-names', "Do not prepend 'g' to the binary"

  def install
    args = ["--prefix=#{prefix}",
            "--localstatedir=#{var}/locate",
            "--disable-dependency-tracking",
            "--disable-debug"]
    args << "--program-prefix=g" unless build.include? 'default-names'

    system "./configure", *args
    system "make install"
  end
end
