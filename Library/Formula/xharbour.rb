require 'formula'

class Xharbour < Formula
  homepage 'http://www.xharbour.org/'
  url 'http://downloads.sourceforge.net/xharbour/xharbour-1.2.1.src.tar.gz'
  sha1 'bd6e004d7f163df644754f1a067f001873fbfc8a'

  depends_on "s-lang"
  depends_on :x11 => :recomended

  def install
    ENV["HB_INSTALL_PREFIX"] = prefix    
  
    if build.include? 'without-x'
      ENV["HB_WITHOUT_X11"]="yes"
    end
    
    ENV.deparallelize
    
    system "sh ./make_macosx.sh"
    system "sh ./make_macosx.sh install"
  end
end
