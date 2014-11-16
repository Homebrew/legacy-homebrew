require 'formula'

class Qstat < Formula
  homepage 'http://qstat.sourceforge.net'
  url 'https://downloads.sourceforge.net/project/qstat/qstat/qstat-2.11/qstat-2.11.tar.gz'
  sha1 '107796ab7512bdfdd0c3bb06a3458432b39458c7'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
