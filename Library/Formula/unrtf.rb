require 'formula'

class Unrtf < Formula
  url 'http://ftp.gnu.org/gnu/unrtf/unrtf-0.21.2.tar.gz'
  homepage 'http://www.gnu.org/software/unrtf/'
  md5 'e0b38d8786f00704ec479a7d261808b8'

  def install
    system "./configure", "LIBS=-liconv", "--prefix=#{prefix}"
    system "make install"
  end
end
