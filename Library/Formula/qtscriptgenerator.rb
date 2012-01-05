require 'formula'

class Qtscriptgenerator < Formula
  url 'http://qtscriptgenerator.googlecode.com/files/qtscriptgenerator-src-0.1.0.tar.gz'
  homepage 'http://code.google.com/p/qtscriptgenerator/'
  md5 'ca4046ad4bda36cd4e21649d4b98886d'

  depends_on 'qt'

  def install
    system 'pwd; cat README;exit 78'
    #system "qmake"
    #system "make install"
  end

  def caveats; <<-EOS.undent
    I dont know how to use this and how useful it is to amarok ??
    EOS
  end
end
