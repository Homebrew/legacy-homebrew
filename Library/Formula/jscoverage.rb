require 'formula'

class Jscoverage < Formula
  url 'http://siliconforks.com/jscoverage/download/jscoverage-0.5.1.tar.bz2'
  homepage 'http://siliconforks.com/jscoverage/'
  md5 'a70d79a6759367fbcc0bcc18d6866ff3'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    bin.install('jscoverage');
    bin.install('jscoverage-server');
  end
end
