require 'brewkit'

class Bash <Formula
  @url='http://ftp.gnu.org/gnu/bash/bash-4.0.tar.gz'
  @homepage='http://www.gnu.org/software/bash/'
  @md5='a90a1b5a6db4838483f05438e05e8eb9'

  depends_on 'readline'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
