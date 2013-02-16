require 'formula'

class Makedepend < Formula
  homepage 'https://www.github.com/ioerror/makedepend/'
  url 'https://github.com/ioerror/makedepend/archive/0.2.tar.gz'
  sha1 '85b3b2a53b401b8bd5be19443960acb1367d3055'
  head 'https://github.com/ioerror/makedepend.git'

  def install
    bin.mkpath
    ENV['DESTDIR'] = prefix
    system 'make', 'install'
  end

  def test
    system 'makedepend', '--version'
  end
end
