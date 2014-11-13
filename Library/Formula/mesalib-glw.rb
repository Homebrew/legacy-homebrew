require 'formula'

class MesalibGlw < Formula
  homepage 'http://www.mesa3d.org'
  url 'https://downloads.sourceforge.net/project/mesa3d/MesaLib/7.2/MesaLib-7.2.tar.gz'
  sha1 '6390ece818ec6fecacaafe3618ae844cf5f92b92'

  bottle do
    cellar :any
    revision 1
    sha1 "617a0490b723c28d7afc30742a7fde7e3aa56c81" => :yosemite
    sha1 "a0ac2d5bd0d31aa471d63c6f81d304a107c03fc5" => :mavericks
    sha1 "35df28b14aca921ef20e9bdd4db35c6c803e8561" => :mountain_lion
  end

  depends_on :x11

  option 'enable-static', "Build static library"

  def install
    args = ["--disable-debug", "--disable-dependency-tracking",
            "--prefix=#{prefix}"]
    args << "--with-driver=xlib"
    args << "--disable-gl-osmesa"
    args << "--disable-glu"
    args << "--disable-glut"

    if build.include? 'enable-static'
      args << "--enable-static"
    end

    system "./configure", *args

    inreplace 'configs/autoconf' do |s|
      s.gsub! /.so/, '.dylib'
      s.gsub! /SRC_DIRS = mesa glw/, 'SRC_DIRS = glw'
      s.gsub! /-L\$\(TOP\)\/\$\(LIB_DIR\)/, "-L#{MacOS::X11.lib}"
    end

    inreplace 'src/glw/Makefile' do |s|
      s.gsub! /-I\$\(TOP\)\/include /, ''
    end

    system "make"

    (include+'GL').mkpath
    (include+'GL').install Dir['src/glw/*.h']
    lib.install Dir['lib/*']
  end
end
