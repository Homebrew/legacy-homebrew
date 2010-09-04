require 'formula'

class GnuTar < Formula
  url 'ftp://ftp.gnu.org/gnu/tar/tar-1.23.tar.gz'
  homepage 'http://www.gnu.org/software/tar/'
  md5 'fe81d950b61cb2f45619e1fcef97ce60'

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
