require 'formula'

class Mathgl < Formula
  homepage 'http://mathgl.sourceforge.net/'
  url 'http://downloads.sourceforge.net/mathgl/mathgl-2.1.2.tar.gz'
  sha1 'bd3e797f8616c1f8afd0955fc9b87a2605cbf5ff'

  option 'fltk',   'Build the fltk widget and mglview using X11'
  option 'qt4',    'Build the Qt widget, the udav gui, and mglview using Qt4'
  option 'wx',     'Build the wxWidget widget'
  option 'gif',    'Build support for GIF'
  option 'hdf5',   'Build support for hdf5'

  depends_on 'cmake'   => :build
  depends_on 'gsl'     => :recommended
  depends_on 'jpeg'    => :recommended
  depends_on 'libharu' => :recommended
  depends_on :libpng   => :recommended
  depends_on 'hdf5'   if build.include? 'hdf5'
  depends_on 'fltk'   if build.include? 'fltk'
  depends_on 'qt'     if build.include? 'qt4'
  depends_on 'wxmac'  if build.include? 'wx'
  depends_on 'giflib' if build.include? 'gif'
  depends_on :x11 if build.include? 'fltk'

  def install
    args = std_cmake_args + %w[
      -Denable-glut=ON
      -Denable-gsl=ON
      -Denable-jpeg=ON
      -Denable-pthread=ON
      -Denable-pdf=ON
      -Denable-python=OFF
      -Denable-octave=OFF
    ]

    args << '-Denable-qt=ON'      if build.include? 'qt4'
    args << '-Denable-gif=ON'     if build.include? 'gif'
    args << '-Denable-hdf5_18=ON' if build.include? 'hdf5'
    args << '-Denable-fltk=ON'    if build.include? 'fltk'
    args << '-Denable-wx=ON'      if build.include? 'wx'
    args << '..'
    rm 'ChangeLog' if File.exist? 'ChangeLog' # rm this problematic symlink.
    mkdir 'brewery' do
      system 'cmake', *args
      system 'make install'
      cd 'examples' do
        bin.install Dir['mgl*_example']
      end
    end
  end

  test do
    system "#{bin}/mgl_example"
  end
end
