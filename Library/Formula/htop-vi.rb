require 'formula'

class HtopVi < Formula
  head 'git://github.com/guns/htop-vi.git', :branch => 'osx-vi-keys'
  homepage 'http://htop.sourceforge.net/'

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--program-suffix='-vi'"
    system "make", "install", "DEFAULT_INCLUDES='-iquote .'"
    rm_rf "#{share}/applications" # Don't need Gnome support on OS X
    rm_rf "#{share}/pixmaps"
  end

  def caveats; <<-EOS.undent
    For htop to display correctly all running processes, it needs to run as root.
    If you don't want to `sudo htop` every time, change the owner and permissions:
        cd #{bin}
        chmod 6555 htop
        sudo chown root htop
    EOS
  end
end
