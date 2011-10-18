require 'formula'

class Winexe < Formula
  url 'http://sourceforge.net/projects/winexe/files/winexe-1.00.tar.gz'
  homepage 'http://sourceforge.net/projects/winexe/'
  md5 '48325521ddc40d14087d1480dc83d51e'

  def patches
    {:p1 => 'https://raw.github.com/gist/1294786/winexe.patch'}
  end

  def install
    Dir.chdir "source4" do
      system "./autogen.sh"
      system "./configure", "--enable-fhs"
      system "make basics idl bin/winexe"
      bin.install "bin/winexe"
    end
  end
end
