require 'formula'

class Makedepend < Formula
  homepage 'https://www.github.com/ioerror/makedepend/'
  head 'https://www.github.com/ioerror/makedepend.git', :using => :git,  :branch => 'master'
  url 'https://github.com/ioerror/makedepend/archive/0.2.tar.gz'
  sha1 '85b3b2a53b401b8bd5be19443960acb1367d3055'

  def install
    system "DESTDIR=#{prefix} make install"
  end

  def test
    system "makedepend"
  end
end
