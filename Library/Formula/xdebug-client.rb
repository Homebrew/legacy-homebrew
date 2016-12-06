require 'formula'

class XdebugClient < Formula
  url 'http://xdebug.org/files/xdebug-2.1.1.tgz'
  homepage 'http://xdebug.org/docs/install#debugclient'
  md5 'fcdf078e715f44b77f13bac721ad63ce'

  depends_on 'xdebug'

  def install
    cd "xdebug-2.1.1/debugclient" do
      system "./configure", "--prefix=#{prefix}", "--with-libedit"
      system "make"
      system "chmod ugo+x install-sh"
      system "make install"
    end
  end
end
