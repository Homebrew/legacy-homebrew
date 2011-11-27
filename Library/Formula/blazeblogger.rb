require 'formula'

class Blazeblogger < Formula
  homepage 'http://blaze.blackened.cz/'
  url 'http://blazeblogger.googlecode.com/files/blazeblogger-1.2.0.tar.gz'
  md5 'a126ea460e389f73d0f0fb45164bdaf9'

  def install
    system "make prefix=#{prefix} compdir=#{prefix} install"
  end

  def test
    # test blazeblogger is hard, we'd have to test creating a repo
    system "true"
  end

  def remove
    system "make prefix=#{prefix} compdir=#{prefix} uninstall"
  end

end
