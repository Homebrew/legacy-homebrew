require 'formula'

class GnuTar < Formula
  url 'ftp://ftp.gnu.org/gnu/tar/tar-1.25.tar.gz'
  homepage 'http://www.gnu.org/software/tar/'
  md5 '0e48e9e473a72f135d0ebbc8af2762cc'

  def options
    [['--default-names', "Do NOT prepend 'g' to the binary; will override system tar."]]
  end

  def install
    args = [ "--prefix=#{prefix}" , "--mandir=#{man}" ]
    args << "--program-prefix=g" unless ARGV.include? '--default-names'

    system "./configure", *args
    system "make install"
  end
end
