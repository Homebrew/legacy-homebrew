require 'formula'

class M4 < Formula
  url 'http://ftpmirror.gnu.org/m4/m4-1.4.16.tar.bz2'
  homepage 'http://www.gnu.org/software/m4/'
  md5 '8a7cef47fecab6272eb86a6be6363b2f'

  depends_on 'libsigsegv' => :optional

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

end
