require 'formula'

class Winexe < Formula
  url 'http://sourceforge.net/projects/winexe/files/winexe-1.00.tar.gz'
  homepage 'http://sourceforge.net/projects/winexe/'
  md5 '48325521ddc40d14087d1480dc83d51e'

  def patches
    # This patch removes second definition of event context, which *should* break the build virtually everywhere,  
    # but for some reason it only breaks it on OS X.
    #
    # There are several instructions over the Internet on how to build winexe for OS X, all of them
    # share the same patch, so original author is unknown. One of the sources:
    #
    # http://miskstuf.tumblr.com/post/6840077505/winexe-1-00-linux-macos-windows-7-finally-working 
    #
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
