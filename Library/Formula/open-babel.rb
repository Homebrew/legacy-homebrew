require 'formula'

class OpenBabel < Formula
  homepage 'http://www.openbabel.org'
  url 'http://sourceforge.net/projects/openbabel/files/openbabel/2.3.2/openbabel-2.3.2.tar.gz'
  sha1 'b8831a308617d1c78a790479523e43524f07d50d'

  option 'gui',    'Build the Graphical User Interface'
  option 'png',    'Support PNG depiction'
  option 'python', 'Compile Python language bindings'
  option 'java',   'Compile Java language bindings'

  depends_on 'cmake' => :build
  depends_on 'wxmac' if build.include? 'gui'
  depends_on 'cairo' if build.include? 'png'
  depends_on 'eigen' if build.include? 'python'
  depends_on 'eigen' if build.include? 'java'

  def install
    args = %W[ -DCMAKE_INSTALL_PREFIX=#{prefix} ]
    args << "-DPYTHON_BINDINGS=ON" if build.include? 'python'
    args << "-DJAVA_BINDINGS=ON" if build.include? 'java'
    args << "-DBUILD_GUI=ON" if build.include? 'gui'
    args << "-DCAIRO_INCLUDE_DIRS=#{include}/cairo "\
    "-DCAIRO_LIBRARIES=#{lib}/libcairo.dylib" if build.include? 'png'
    args << '..'

    mkdir 'build' do
      system "cmake", *args
      system "make"
      system "make install"
    end

    if build.include? 'python'
      pydir = lib/which_python/'site-packages'
      pydir.mkpath
      mv lib/'openbabel.py', pydir
      mv lib/'pybel.py', pydir
      cd pydir do
      `python -c 'import py_compile;py_compile.compile(\"openbabel.py\");py_compile.compile(\"pybel.py\")'`
      end
    end
  end

  def caveats; <<-EOS.undent
    Python modules are installed to #{HOMEBREW_PREFIX}/lib/#{which_python}/site-packages
    so the PYTHONPATH environment variable should include the paths
    #{HOMEBREW_PREFIX}/lib/#{which_python}/site-packages:#{HOMEBREW_PREFIX}/lib

    Java libraries are installed to #{HOMEBREW_PREFIX}/lib so this path should be
    included in the CLASSPATH environment variable.
    EOS
  end

  def which_python
    "python" + `python -c 'import sys;print(sys.version[:3])'`.strip
  end
end
