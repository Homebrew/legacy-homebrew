require 'formula'

class Lifelines < Formula
  homepage 'http://lifelines.sourceforge.net/'
  url 'http://sourceforge.net/projects/lifelines/files/lifelines/3.0.62/lifelines-3.0.62.tar.gz'
  sha1 'cbb215167082b9f029e03c86c143d30148e8d3c1'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
