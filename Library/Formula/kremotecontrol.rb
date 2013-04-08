require 'base_kde_formula'

class Kremotecontrol < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kremotecontrol-4.10.2.tar.xz'
  sha1 'e74d4724afef6fdfb5b4a95e35672b3e3d8e9b5c'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kremotecontrol-4.10.2.tar.xz'
    sha1 'e74d4724afef6fdfb5b4a95e35672b3e3d8e9b5c'
  end

  depends_on 'kdelibs'
end
