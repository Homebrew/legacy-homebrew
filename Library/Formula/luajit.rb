require 'formula'

class Luajit < Formula
  url 'http://luajit.org/download/LuaJIT-2.0.0-beta8.tar.gz'
  head 'http://luajit.org/git/luajit-2.0.git', :using => :git
  homepage 'http://luajit.org/luajit.html'
  md5 'f0748a73ae268d49b1d01f56c4fe3e61'

  # Skip cleaning both empty folders and bin/libs so external symbols still work.
  skip_clean :all

  fails_with_llvm "_Unwind_Exception_Class undeclared", :build => 2336

  def options
    [["--debug", "Build with debugging symbols."]]
  end

  # Apply beta8 hotfix #1
  def patches
    if not ARGV.build_head?
      { :p1 => "http://luajit.org/download/beta8_hotfix1.patch" }
    end
  end

  def install
    if ARGV.include? '--debug'
      system "make", "CCDEBUG=-g", "PREFIX=#{prefix}",
             "TARGET_CC=#{ENV['CC']}",
             "amalg"
      system "make", "CCDEBUG=-g", "PREFIX=#{prefix}",
             "TARGET_CC=#{ENV['CC']}",
             "install"
    else
      system "make", "PREFIX=#{prefix}",
             "TARGET_CC=#{ENV['CC']}",
             "amalg"
      system "make", "PREFIX=#{prefix}",
             "TARGET_CC=#{ENV['CC']}",
             "install"
    end

    # Non-versioned symlink
    if ARGV.build_head?
      version = "2.0.0-beta8"
    else
      version = @version
    end
    ln_s bin+"luajit-#{version}", bin+"luajit"
  end
end
