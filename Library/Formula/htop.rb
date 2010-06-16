require 'formula'

class Htop <Formula
  head 'git://github.com/AndyA/htop-osx.git', :branch => 'osx'
  homepage 'http://htop.sourceforge.net/'

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make", "install", "DEFAULT_INCLUDES='-iquote .'"
    rm_rf "#{share}/applications" # Don't need Gnome support on OS X
    rm_rf "#{share}/pixmaps"
  end

  def caveats; <<-EOS
In order for htop to display correctly all the running processes, it needs to be ran as root.

However, if you do not want to type `sudo htop` every time, you can change the owner and permissions for the executable binary:

$ cd #{prefix}/bin/
$ chmod 6555 htop
$ sudo chown root htop
    EOS
  end

end
