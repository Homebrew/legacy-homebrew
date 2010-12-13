require 'formula'

class Autobench < Formula
  url 'http://www.xenoclast.org/autobench/downloads/autobench-2.1.2.tar.gz'
  homepage 'http://www.xenoclast.org/autobench/'
  md5 'dbd00818840ed8d3c3d35734f0353cff'

  depends_on 'httperf'

  def install
    inreplace "Makefile" do |s|
      s.change_make_var! 'PREFIX', prefix
      s.change_make_var! 'MANDIR', man1
    end
    system "make"
    system "make install"
  end
end
