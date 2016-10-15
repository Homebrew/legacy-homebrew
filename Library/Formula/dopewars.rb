require "formula"

class Dopewars < Formula
  homepage "http://dopewars.sourceforge.net/"
  url "https://downloads.sourceforge.net/dopewars/dopewars-1.5.12.tar.gz"
  sha1 "ad46a38e225680e591b078eeec563d47b96684bc"
  option 'enable-gui-client', "Enable the GTK+ GUI client"

  depends_on "glib"
  env :std # if superenv is used, configure script does not detect GLib

  def install
    inreplace "src/Makefile.in", "$(dopewars_DEPENDENCIES)", ""
    inreplace "ltmain.sh", "need_relink=yes", "need_relink=no"
    inreplace "src/plugins/Makefile.in", "LIBADD =", "LIBADD = -module -avoid-version"
      if build.include? 'enable-gui-client'
        depends_on 'marekjelen/gtk/gtk+-quartz'
        ENV['dopewars_homebrew_gui_client'] = "--enable-gui-client"
        ENV['dopewars_homebrew_arch'] = "--build=i386"
    else
        ENV['dopewars_homebrew_gui_client'] = "--disable-gui-client"
        ENV['dopewars_homebrew_arch'] = "--build=x86_64"
      end
    system "./configure", "#{ENV['dopewars_homebrew_arch']}",
                          "#{ENV['dopewars_homebrew_gui_client']}",
                          "--enable-plugins",
                          "--enable-networking",
                          "--disable-gui-server",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--disable-debug",
                          "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    system "dopewars"
  end
end
