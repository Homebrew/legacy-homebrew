require 'formula'

class Minised < Formula
  url 'http://dl.exactcode.de/oss/minised/minised-1.13.tar.gz'
  homepage 'http://www.exactcode.de/site/open_source/minised/'
  md5 '2a43b1bbf1654ef7fab9d8c4f6c979a1'

  def install
    inreplace "Makefile" do |s|
      s.change_make_var! "DESTDIR", prefix
      s.change_make_var! "PREFIX", ""
    end

    system "make"
    system "make install"
  end
end
