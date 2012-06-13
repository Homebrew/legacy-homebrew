require 'formula'

class Vtk < Formula
  homepage 'http://www.vtk.org'
  url 'http://www.vtk.org/files/release/5.10/vtk-5.10.0.tar.gz'
  sha1 '0c9a17e2f446dc78b0500dc5bbd1c6a2864a0191'

  depends_on 'cmake' => :build
  depends_on :x11 if ARGV.include? '--x11'
  depends_on 'qt' if ARGV.include? '--qt'
  depends_on 'sip' if ARGV.include? '--pyqt' and ARGV.include? '--python'
  depends_on 'pyqt' if ARGV.include? '--pyqt' and ARGV.include? '--python'

  skip_clean :all  # Otherwise vtkpython complains can't find symbol _environ

  def options
  [
    ['--examples',  'Compile and install various examples.'],
    ['--python',    'Enable python wrapping of VTK classes.'],
    ['--pyqt',      'Make python wrapped classes available to SIP/PyQt.'],
    ['--qt',        'Enable Qt4 extension via the Homebrew qt formula.'],
    ['--qt-extern', 'Enable Qt4 extension via non-Homebrew external Qt4.'],
    ['--tcl',       'Enable Tcl wrapping of VTK classes.'],
    ['--x11',       'Enable X11 extension rather than OSX native Aqua.']
  ]
  end

  def install
    args = std_cmake_args + %W[
      -DVTK_REQUIRED_OBJCXX_FLAGS=''
      -DVTK_USE_CARBON=OFF
      -DBUILD_TESTING=OFF
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH:STRING='#{lib}/vtk-5.10'
      -DCMAKE_INSTALL_NAME_DIR:STRING='#{lib}/vtk-5.10'
    ]

    args << '-DBUILD_EXAMPLES=' + ((ARGV.include? '--examples') ? 'ON' : 'OFF')

    if ARGV.include? '--python'
      python_prefix = `python-config --prefix`.strip
      # Install to lib and let installer symlink to global python site-packages.
      # The path in lib needs to exist first and be listed in PYTHONPATH.
      pydir = lib/which_python/'site-packages'
      pydir.mkpath
      ENV.prepend 'PYTHONPATH', pydir, ':'
      args << "-DVTK_PYTHON_SETUP_ARGS='--prefix=#{prefix}'"
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
        python_version = `python-config --libs`.match('-lpython(\d+\.\d+)').captures.at(0)
        python_lib = "#{python_prefix}/lib/libpython#{python_version}"
        if File.exists? "#{python_lib}.a"
          args << "-DPYTHON_LIBRARY='#{python_lib}.a'"
        else
          args << "-DPYTHON_LIBRARY='#{python_lib}.dylib'"
        end
        args << "-DPYTHON_INCLUDE_DIR='#{python_prefix}/include/#{which_python}'"
      end
      args << '-DVTK_WRAP_PYTHON=ON'
      if ARGV.include? '--pyqt'
        args << '-DVTK_WRAP_PYTHON_SIP=ON'
        args << "-DSIP_PYQT_DIR='#{HOMEBREW_PREFIX}/share/sip'"
      end
    end

    if ARGV.include? '--qt' or ARGV.include? '--qt-extern'
      args << '-DVTK_USE_GUISUPPORT=ON'
      args << '-DVTK_USE_QT=ON'
      args << '-DVTK_USE_QVTK=ON'
    end

    args << '-DVTK_WRAP_TCL=ON' if ARGV.include? '--tcl'

    # default to cocoa for everything except x11
    if ARGV.include? '--x11'
      args << '-DVTK_USE_COCOA=OFF'
      args << '-DVTK_USE_X=ON'
    else
      args << '-DVTK_USE_COCOA=ON'
    end

    unless MacOS::CLT.installed?
      # We are facing an Xcode-only installation, and we have to keep
      # vtk from using its internal Tk headers (that differ from OSX's).
      args << "-DTK_INCLUDE_PATH:PATH=#{MacOS.sdk_path}/System/Library/Frameworks/Tk.framework/Headers"
      args << "-DTK_INTERNAL_PATH:PATH=#{MacOS.sdk_path}/System/Library/Frameworks/Tk.framework/Headers/tk-private"
    end

    args << ".."

    mkdir 'build' do
      system 'cmake', *args
      system 'make'
      system 'make install'
    end

    (share+'vtk').install 'Examples' if ARGV.include? '--examples'

    # Finalize a couple of Python issues due to our installing into the cellar.
    if ARGV.include? '--python'
      # Avoid the .egg and use the python module right away, because
      # system python does not read .pth files from our site-packages.
      mv pydir/'VTK-5.10.0-py2.7.egg/vtk', pydir/'vtk'

      # Remove files with duplicates in /usr/local/lib/python2.7/site-packages
      %w(site.py site.pyc easy-install.pth VTK-5.10.0-py2.7.egg).each do |f|
        rmtree pydir/f
      end
    end
  end

  def caveats
    s = ''
    vtk = Tab.for_formula 'vtk'
    if ARGV.include? '--python' or vtk.installed_with? '--python'
      s += <<-EOS.undent
        For non-homebrew Python, you need to amend your PYTHONPATH like so:
        export PYTHONPATH=#{HOMEBREW_PREFIX}/lib/#{which_python}/site-packages:$PYTHONPATH

        Even without the --pyqt option, you can display native VTK render windows
        from python. Alternatively, you can integrate the RenderWindowInteractor
        in PyQt, PySide, Tk or Wx at runtime. Look at
            import vtk.qt4; help(vtk.qt4) or import vtk.wx; help(vtk.wx)

      EOS
    end
    if ARGV.include? '--examples' or vtk.installed_with? '--examples'
      s += <<-EOS.undent

        The scripting examples are stored in #{HOMEBREW_PREFIX}/share/vtk

      EOS
    end
    return s.empty? ? nil : s
  end

  def which_python
    "python" + `python -c 'import sys;print(sys.version[:3])'`.strip
  end
end
