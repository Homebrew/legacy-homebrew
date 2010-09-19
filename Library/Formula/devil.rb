require 'formula'

class Devil <Formula
  url 'http://downloads.sourceforge.net/openil/1.7.8/DevIL-1.7.8.tar.gz'
  homepage 'http://sourceforge.net/projects/openil/'
  md5 '7918f215524589435e5ec2e8736d5e1d'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
