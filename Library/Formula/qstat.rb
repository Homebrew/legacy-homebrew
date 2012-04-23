require 'formula'

class Qstat < Formula
  homepage 'http://qstat.sourceforge.net'
  url 'http://sourceforge.net/projects/qstat/files/qstat/qstat-2.11/qstat-2.11.tar.gz'
  md5 '26c09831660ef9049fe74b786b80d091'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "qstat"
  end
end
