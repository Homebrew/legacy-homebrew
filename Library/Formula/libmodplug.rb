require 'formula'

class Libmodplug <Formula
  url 'http://downloads.sourceforge.net/project/modplug-xmms/libmodplug/0.8.8.1/libmodplug-0.8.8.1.tar.gz'
  homepage 'http://modplug-xmms.sourceforge.net/'
  md5 'f7fa53a60c650024ff51cca88341776b'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
