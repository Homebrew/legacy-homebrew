require 'formula'

def use_default_names?
  ARGV.include? '--default-names'
end

class GnuSed <Formula
  url 'http://ftp.gnu.org/gnu/sed/sed-4.2.1.tar.bz2'
  homepage 'http://www.gnu.org/software/sed/'
  md5 '7d310fbd76e01a01115075c1fd3f455a'

  def options
    [['--default-names', "Do NOT prepend 'g' to the binary; will override system utils."]]
  end

  def install
    args = ["--prefix=#{prefix}", "--disable-dependency-tracking"]
    args << "--program-prefix=g" unless use_default_names?

    system "./configure", *args
    system "make install"
  end
end
