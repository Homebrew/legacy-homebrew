require 'formula'

class Openbabel < Formula
  homepage 'http://www.openbabel.org'
  url 'http://sourceforge.net/projects/openbabel/files/openbabel/2.3.2/openbabel-2.3.2.tar.gz'
  sha1 'b8831a308617d1c78a790479523e43524f07d50d'

  option 'build-gui',       'Build the Graphical User Interface'
  option 'png',             'Support PNG depiction'
  option 'python-bindings', 'Compile Python language bindings'

  depends_on 'cmake' => :build
  depends_on 'wxmac' if build.include? 'build-gui'
  depends_on 'cairo' if build.include? 'png'
  depends_on 'eigen' if build.include? 'python-bindings'

  def install
    args = %W[ -DCMAKE_INSTALL_PREFIX=#{prefix} ]
    args << '-DPYTHON_BINDINGS=ON' if build.include? 'python-bindings'
    args << '-DBUILD_GUI=ON' if build.include? 'build-gui'
    args << '-DCAIRO_INCLUDE_DIRS=/usr/local/include/cairo '\
            '-DCAIRO_LIBRARIES=/usr/local/lib/libcairo.dylib' if build.include? 'png'

    system "mkdir ../build"
    system "cd ../build"
    system "cmake", *args
    system "make"
    system "make install"
  end

  def caveats; <<-EOS.undent
    Language bindings will be installed to the same location as the
    Open Babel libraries (/usr/local/lib).
    To prepare to use the bindings, add the install directory to the
    front of the appropriate environment variable:
    PYTHONPATH for Python.
    EOS
  end
end
