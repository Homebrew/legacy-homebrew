require 'formula'

class Makedepend < Formula
  homepage 'https://www.github.com/ioerror/makedepend/'
  head 'https://www.github.com/ioerror/makedepend.git', :using => :git,  :branch => 'master'
  url 'https://www.github.com/ioerror/makedepend.git', :using => :git,  :branch => 'master', tag: => '0.1'

  def install
    system "make install"
  end

  def test
    system "makedepend"
  end
end
