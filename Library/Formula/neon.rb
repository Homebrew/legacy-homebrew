require 'formula'

class Neon <Formula
  @url='http://www.webdav.org/neon/neon-0.29.0.tar.gz'
  @homepage='http://www.webdav.org/neon/'
  @md5='18a3764b70f9317f8b61509fd90d9e7a'

  def keg_only?
    :provided_by_osx
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug", 
                          "--disable-dependency-tracking",
                          "--enable-shared",
                          "--disable-static",
                          "--with-ssl"
    system "make install"
  end
end
