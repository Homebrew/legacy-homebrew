require 'formula'

class Poppler <Formula
  url 'http://poppler.freedesktop.org/poppler-0.12.2.tar.gz'
  homepage 'http://poppler.freedesktop.org/'
  md5 '60c00b55acf7dd389bf256d178af70bf'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
