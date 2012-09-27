require 'formula'

class GnuTar < Formula
  homepage 'http://www.gnu.org/software/tar/'
  url 'http://ftpmirror.gnu.org/tar/tar-1.26.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/tar/tar-1.26.tar.gz'
  sha1 'ba89cba98c1a6aea3c80cda5ddcd5eceb5adbb9b'

  option 'default-names', "Do not prepend 'g' to the binary"

  def install
    args = ["--prefix=#{prefix}", "--mandir=#{man}"]
    args << "--program-prefix=g" unless build.include? 'default-names'

    system "./configure", *args
    system "make install"
  end
end
