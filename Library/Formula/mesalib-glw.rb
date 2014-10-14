require 'formula'

class MesalibGlw < Formula
  homepage 'http://www.mesa3d.org'
  url 'https://downloads.sourceforge.net/project/mesa3d/MesaLib/7.2/MesaLib-7.2.tar.gz'
  sha1 '6390ece818ec6fecacaafe3618ae844cf5f92b92'

  bottle do
    cellar :any
    sha1 "e585f5909a5bb42a2ac7cba52226a8421d437573" => :mavericks
    sha1 "ffa2c628918d0e48f139cb4c2390d4df11d26be0" => :mountain_lion
    sha1 "728b8a6ae9aaca91290eca05d35595b4bc1c7b77" => :lion
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
