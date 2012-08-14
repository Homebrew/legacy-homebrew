require 'formula'

class Lifelines < Formula
  homepage 'http://lifelines.sourceforge.net/'
  url 'http://sourceforge.net/projects/lifelines/files/lifelines/3.0.62/lifelines-3.0.62.tar.gz'
  md5 'ff617e64205763c239b0805d8bbe19fe'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
