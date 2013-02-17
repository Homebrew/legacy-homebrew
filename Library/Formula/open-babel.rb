require 'formula'

class OpenBabel < Formula
  homepage 'http://www.openbabel.org'
  url 'http://sourceforge.net/projects/openbabel/files/openbabel/2.3.2/openbabel-2.3.2.tar.gz'
  sha1 'b8831a308617d1c78a790479523e43524f07d50d'

  option 'gui',    'Build the Graphical User Interface'
  option 'png',    'Support PNG depiction'
  option 'python', 'Compile Python language bindings'
  option 'java',   'Compile Java language bindings'

  depends_on 'pkg-config' => :build
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

    # Find the right pyhton installation (code from opencv.rb)
    if build.include? 'python'
      python_prefix = `python-config --prefix`.strip
      # Python is actually a library. The libpythonX.Y.dylib points to this lib, too.
      if File.exist? "#{python_prefix}/Python"
        # Python was compiled with --framework:
        args << "-DPYTHON_LIBRARY='#{python_prefix}/Python'"
        if !MacOS::CLT.installed? and python_prefix.start_with? '/System/Library'
          # For Xcode-only systems, the headers of system's python are inside of Xcode
          args << "-DPYTHON_INCLUDE_DIR='#{MacOS.sdk_path}/System/Library/Frameworks/Python.framework/Versions/2.7/Headers'"
        else
          args << "-DPYTHON_INCLUDE_DIR='#{python_prefix}/Headers'"
        end
      else
        python_lib = "#{python_prefix}/lib/lib#{which_python}"
        if File.exists? "#{python_lib}.a"
          args << "-DPYTHON_LIBRARY='#{python_lib}.a'"
        else
          args << "-DPYTHON_LIBRARY='#{python_lib}.dylib'"
        end
        args << "-DPYTHON_INCLUDE_DIR='#{python_prefix}/include/#{which_python}'"
      end
      args << "-DPYTHON_PACKAGES_PATH='#{lib}/#{which_python}/site-packages'"
    end

    args << '..'

    mkdir 'build' do
      system "cmake", *args
      system "make"
      system "make install"
    end

    if build.include? 'python'
      pydir = lib/which_python/'site-packages'
      pydir.install lib/'openbabel.py', lib/'pybel.py'
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
