require 'formula'

class Htop <Formula
  head 'git://github.com/AndyA/htop-osx.git', :branch => 'osx'
  homepage 'http://htop.sourceforge.net/'

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install", "DEFAULT_INCLUDES='-iquote .'"
    rm_rf "#{share}/applications" # Don't need Gnome support on OS X
    rm_rf "#{share}/pixmaps"
  end

  def caveats; <<-EOS
For htop to display correctly all running processes, it needs to run as root.
If you don't want to `sudo htop` every time, change the owner and permissions:
  $ cd #{bin}
  $ chmod 6555 htop
  $ sudo chown root htop
    EOS
  end
end
