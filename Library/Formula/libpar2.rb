require 'formula'

class Libpar2 <Formula
  url 'http://sourceforge.net/projects/parchive/files/libpar2/0.2/libpar2-0.2.tar.gz'
  homepage 'http://parchive.sourceforge.net/'
  md5 '94c6df4e38efe08056ecde2a04e0be91'

  depends_on 'pkg-config' => :build
  depends_on 'libsigc++'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
