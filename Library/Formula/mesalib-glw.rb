require 'formula'

class MesalibGlw < Formula
  url 'http://downloads.sourceforge.net/project/mesa3d/MesaLib/7.2/MesaLib-7.2.tar.gz'
  homepage 'http://www.mesa3d.org'
  md5 '81a2a4b7cbfce7553f7ad8d924edbe2f'

  def options
    [
      ['--enable-static', "build static library"]
    ]
  end

  def install
    args = ["--disable-debug", "--disable-dependency-tracking",
            "--prefix=#{prefix}"]
    args << "--with-driver=xlib"
    args << "--disable-gl-osmesa"
    args << "--disable-glu"
    args << "--disable-glut"

    if ARGV.include? '--enable-static'
      args << "--enable-static"
    end

    system "./configure", *args

    inreplace 'configs/autoconf' do |s|
      s.gsub! /.so/, '.dylib'
      s.gsub! /SRC_DIRS = mesa glw/, 'SRC_DIRS = glw'
      s.gsub! /-L\$\(TOP\)\/\$\(LIB_DIR\)/, '-L/usr/X11/lib'
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
