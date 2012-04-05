require 'formula'

class Dfc < Formula
  homepage 'http://projects.gw-computing.net/projects/dfc'
  url 'http://projects.gw-computing.net/attachments/download/42/dfc-2.5.0.tar.gz'
  md5 'e9c5e862858ab2cd4a7b2270c26722ef'

  def install
    system "make"
    system "make PREFIX=#{prefix} install"
    share.mkdir
    system "mv #{prefix}/man #{share}"
  end

  def test
    system "dfc"
  end
end
