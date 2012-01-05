require 'formula'

class Amarok < Formula
  url 'ftp://ftp.gtlib.cc.gatech.edu/pub/kde/stable/amarok/2.5.0/src/amarok-2.5.0.tar.bz2'
  homepage 'http://amarok.kde.org/'
  md5 'b7983eaa33e4771769ae9e330c811995'

  # Required
  depends_on 'cmake' => :build
  depends_on 'kdelibs'
  #depends_on 'zlib'
  depends_on 'curl'
  depends_on 'libxml2'
  depends_on 'openssl'
  depends_on 'mysql'
  # Optional
  depends_on 'loudmouth'
  depends_on 'libmtp'
  depends_on 'gdk-pixbuf'
  depends_on 'libgpod'
  #depends_on 'libmygpo-qt'
  depends_on 'ffmpeg'
  depends_on 'liblastfm'
  depends_on 'QJson'
  depends_on 'qca'
  #depends_on 'qtscript-qt'
  

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end

end
