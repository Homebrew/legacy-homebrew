require 'formula'

class Therion < Formula
  homepage 'http://therion.speleo.sk'
  url 'http://therion.speleo.sk/downloads/therion-5.3.12.tar.gz'
  sha1 '6c9863225f87ce4b54792060ecb34a9db6f8197e'

  #depends_on 'cmake' => :build
  depends_on 'lcdf-typetools'
  depends_on 'wxmac'
  depends_on 'freetype'
  depends_on 'vtk5'
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
