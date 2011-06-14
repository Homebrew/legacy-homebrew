require 'formula'

class Luajit < Formula
  url 'http://luajit.org/download/LuaJIT-2.0.0-beta7.tar.gz'
  head 'http://luajit.org/git/luajit-2.0.git', :using => :git
  homepage 'http://luajit.org/luajit.html'
  md5 'b845dec15dd9eba2fd17d865601a52e5'

  # Skip cleaning both empty folders and bin/libs so external symbols still work.
  skip_clean :all

  def install
    system "make", "PREFIX=#{prefix}", "install"
    # Non-versioned symlink
    ln_s bin+"luajit-#{version}", bin+"luajit"
  end
end
