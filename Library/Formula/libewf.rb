require 'formula'

class Libewf < Formula
  url 'http://downloads.sourceforge.net/project/libewf/libewf/libewf-20100226/libewf-20100226.tar.gz'
  homepage 'http://sourceforge.net/projects/libewf/'
  md5 'a697d629bb74df1fa68f22658634fdb9'

  def install
    ENV['LIBTOOLIZE'] = "/usr/bin/glibtoolize"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
