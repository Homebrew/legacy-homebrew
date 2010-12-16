require 'formula'

class Xz <Formula
  url 'http://tukaani.org/xz/xz-5.0.0.tar.bz2'
  homepage 'http://tukaani.org/xz/'
  md5 '0652c09fdbb93ae2ce78c1368ffda612'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
