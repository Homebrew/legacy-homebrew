require 'formula'

class Wyrd <Formula
  url 'http://pessimization.com/software/wyrd/wyrd-1.4.4.tar.gz'
  homepage 'http://pessimization.com/software/wyrd/'
  md5 'a376c05ba614625da06082d850c742c7'

  depends_on 'remind'
  depends_on 'objective-caml'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-utf8"
    system "make"
    system "make install"
  end
end
