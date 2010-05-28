require 'formula'

class Luajit <Formula
  url 'http://luajit.org/download/LuaJIT-2.0.0-beta4.tar.gz'
  head 'http://luajit.org/git/luajit-2.0.git', :using => :git
  homepage 'http://luajit.org/'
  md5 '5c5a9305b3e06765e1dae138e1a95c3a'

  depends_on 'lua'

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end
end
