require 'formula'

class Xz <Formula
  url 'http://tukaani.org/xz/xz-5.0.1.tar.bz2'
  homepage 'http://tukaani.org/xz/'
  md5 'cb6c7a58cec4d663a395c54d186ca0c6'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
