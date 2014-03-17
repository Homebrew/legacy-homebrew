require 'formula'

class Therion < Formula
  homepage 'http://therion.speleo.sk'
  url 'http://therion.speleo.sk/downloads/therion-5.3.14.tar.gz'
  sha1 '087658e9057d6ae520df12a6a07acf2898e657b3'

  #depends_on 'cmake' => :build
  depends_on 'lcdf-typetools'
  depends_on 'wxmac'
  depends_on 'freetype'
  depends_on 'vtk'
  depends_on 'imagemagick'
  depends_on :tex

  def install
    inreplace 'makeinstall.tcl', "/usr/bin" , "#{bin}"
    inreplace 'makeinstall.tcl', "/etc" , "#{etc}"

    (etc).mkpath
    (bin).mkpath
    system "make config-macosx"
    system "make"
    system "make install"
  end

  test do
    system "#{bin}/therion", "--version"
  end
end
