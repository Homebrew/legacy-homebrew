require 'formula'

class Wxmaxima < Formula
  homepage 'http://andrejv.github.com/wxmaxima'
  url 'https://sourceforge.net/projects/wxmaxima/files/wxMaxima/12.09.0/wxMaxima-12.09.0.tar.gz'
  sha1 '9b56f674392eabb75183b228757df8834b45b2a6'

  depends_on 'wxmac'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system 'make'
    cd 'locales' do
      system 'make', 'allmo'
    end
    system 'make', 'wxMaxima.app'
    prefix.install 'wxMaxima.app'
    system "make install"
  end

  def caveats
    <<-EOS.undent
      The program you want to run is wxmaxima.app, and it gets installed into:
        #{prefix}

       To symlink it into Applications, you can type:
         ln -s #{prefix}/wxmaxima.app /Applications

       When you start wxmaxima the first time, you have to open Preferences,
       and tell it where maxima is located.

    EOS
  end
end
