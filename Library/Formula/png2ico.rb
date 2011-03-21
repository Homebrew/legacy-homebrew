require 'formula'

class Png2ico < Formula
  url 'http://www.winterdrache.de/freeware/png2ico/data/png2ico-src-2002-12-08.tar.gz'
  homepage 'http://www.winterdrache.de/freeware/png2ico/'
  md5 '9b663df81c826cd564638cba2e6bc75b'

  def install
    ENV.x11 # For libpng
    # Remove hard-coded CPPFLAGS and replace with Homebrew's flags
    inreplace 'Makefile' do |s|
      s.remove_make_var! 'CPPFLAGS'
      s.gsub! '$(CPPFLAGS)', '$(CPPFLAGS) $(LDFLAGS) $(CFLAGS) -finline-functions'
    end

    system 'make'
    bin.install 'png2ico'
    man1.install 'doc/png2ico.1'
  end
end
