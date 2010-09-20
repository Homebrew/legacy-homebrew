require 'formula'

class Afflib <Formula
  url 'http://afflib.org/downloads/afflib-3.6.2.tar.gz'
  homepage 'http://afflib.org'
  md5 'c30468c762c8e06776410ca8fb56b782'

  depends_on 'expat'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
