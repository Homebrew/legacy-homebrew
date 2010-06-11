require 'formula'

class Png2ico <Formula
  url 'http://www.winterdrache.de/freeware/png2ico/data/png2ico-src-2002-12-08.tar.gz'
  homepage 'http://www.winterdrache.de/freeware/png2ico/'
  md5 '9b663df81c826cd564638cba2e6bc75b'
  
  depends_on 'libpng'

  def install
    # comment out CPPFLAGS so libpng can add -I and -L flags properly
    inreplace 'Makefile', 'CPPFLAGS=-W -Wall -O2 -finline-functions', '#CPPFLAGS=-W -Wall -O2 -finline-functions'
    inreplace 'Makefile', '$(CPPFLAGS)', '$(CPPFLAGS) $(LDFLAGS) $(CFLAGS) -W -Wall -O2 -finline-functions'
    system 'make'
    bin.install 'png2ico'
    man1.install 'doc/png2ico.1'
  end
end