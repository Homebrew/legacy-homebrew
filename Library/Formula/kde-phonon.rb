require 'formula'

class KdePhonon <Formula
  url 'ftp://ftp.kde.org/pub/kde/stable/phonon/4.4.2/phonon-4.4.2.tar.bz2'
  homepage 'http://phonon.kde.org/'
  md5 'd9eab28383783261254f1cef3b92a3fa'

  depends_on 'cmake' => :build
  depends_on 'automoc4' => :build
  depends_on 'qt'

  keg_only "This package is already supplied by Qt and is only needed by KDE packages."

  def patches
    # Add missing QUuid include; committed upstream.
    "http://gitorious.org/phonon/phonon/commit/8e96bbfb1ab4b1c75e4c417549fcc0d3ae9e2183.patch"
  end

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
