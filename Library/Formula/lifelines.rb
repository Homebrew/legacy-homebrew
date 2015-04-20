require 'formula'

class Lifelines < Formula
  homepage 'http://lifelines.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/lifelines/lifelines/3.0.62/lifelines-3.0.62.tar.gz'
  sha1 'cbb215167082b9f029e03c86c143d30148e8d3c1'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
