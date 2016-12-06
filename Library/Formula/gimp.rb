require 'formula'

class Gimp <Formula
  url 'http://sourceforge.net/projects/gimponosx/files/GIMP%20Snow%20Leopard/2.6.11/GIMP-2.6.11-Snow-Leopard.dmg/download',
    :using => :nounzip
  homepage 'http://sourceforge.net/projects/gimponosx/'
  md5 'a7eeda99a3d83224412a87c62c150cd7'
  version '2.6.11-Snow-Leopard'

  def install
    applications = Pathname.new(ENV['HOME'] + '/Applications/')
    if (applications + 'Gimp.app').exist?
        onoe "GIMP is already installed at ~/Application/Gimp.app."
    elsif x11_installed?
      dmg = Pathname.new(@url).basename
      volume = Pathname.new('/Volumes/GIMP 2.6.11 Snow Leopard')
      system "hdiutil", "attach", "-quiet", dmg
      bin.mkpath
      (volume + 'Gimp.app').cp bin
      (volume + 'ChangeLog').cp prefix
      (volume + 'Important notes.rtf').cp prefix
      (volume + 'License').cp prefix
      ln_s(bin + 'Gimp.app', applications)
      system "hdiutil", "detach", "-quiet", volume
    else
       onoe "X11 must be installed."
    end
  end
end
