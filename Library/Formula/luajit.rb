require 'formula'

class Luajit < Formula
  url 'http://luajit.org/download/LuaJIT-2.0.0-beta6.tar.gz'
  head 'http://luajit.org/git/luajit-2.0.git', :using => :git
  homepage 'http://luajit.org/luajit.html'
  md5 'bfcbe2a11162cfa84d5a1693b442c8bf'

  # Skip cleaning both empty folders and bin/libs so external symbols still work.
  skip_clean :all

  def install
    system "make", "PREFIX=#{prefix}", "install"
    # Non-versioned symlink
    ln_s bin+"luajit-#{version}", bin+"luajit"
  end
end
