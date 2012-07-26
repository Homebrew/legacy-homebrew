require 'formula'

class Xspringies < Formula
  homepage 'http://www.cs.rutgers.edu/~decarlo/software.html'
  url 'http://www.cs.rutgers.edu/~decarlo/software/xspringies-1.12.tar.Z'
  md5 '14b14916471874e9d0569ab5f4e8d492'

  depends_on :x11

  def install
    inreplace 'Makefile.std' do |s|
      s.change_make_var! "LIBS", "-L#{MacOS::XQuartz.lib} -lm -lX11"
      s.gsub! 'mkdirhier', 'mkdir -p'
    end
    system "make", "-f", "Makefile.std", "DDIR=#{prefix}/", "install"
  end
end
