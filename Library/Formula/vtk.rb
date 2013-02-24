require 'formula'

class Vtk < Formula
  homepage 'http://www.vtk.org'
  url 'http://www.vtk.org/files/release/5.10/vtk-5.10.1.tar.gz'
  sha1 'deb834f46b3f7fc3e122ddff45e2354d69d2adc3'

  depends_on 'cmake' => :build
<<<<<<< HEAD
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
=======
  depends_on :x11 if build.include? 'x11'
  depends_on 'qt' if build.include? 'qt'

  if build.include? 'pyqt' and build.include? 'python'
    depends_on  'sip'
    depends_on  'pyqt'
>>>>>>> 0dba76a6beda38e9e5357faaf3339408dcea0879
  end

  option 'examples',  'Compile and install various examples'
  option 'python',    'Enable python wrapping of VTK classes'
  option 'pyqt',      'Make python wrapped classes available to SIP/PyQt'
  option 'qt',        'Enable Qt4 extension via the Homebrew qt formula'
  option 'qt-extern', 'Enable Qt4 extension via non-Homebrew external Qt4'
  option 'tcl',       'Enable Tcl wrapping of VTK classes'
  option 'x11',       'Enable X11 extension rather than OSX native Aqua'

  def patches
    # Fix bug in Wrapping/Python/setup_install_paths.py: http://vtk.org/Bug/view.php?id=13699
    DATA
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

<<<<<<< HEAD
    args << '-DBUILD_EXAMPLES=' + ((ARGV.include? '--examples') ? 'ON' : 'OFF')

    if ARGV.include? '--python'
=======
    args << '-DBUILD_EXAMPLES=' + ((build.include? 'examples') ? 'ON' : 'OFF')

    if build.include? 'python'
<<<<<<< HEAD
>>>>>>> 0dba76a6beda38e9e5357faaf3339408dcea0879
=======
      args << '-DVTK_WRAP_PYTHON=ON'

      # Cmake picks up the system's python dylib, even if we have a brewed one.
>>>>>>> 35b0414670cc73c4050f911c89fc1602fa6a1d40
      python_prefix = `python-config --prefix`.strip
      args << "-DPYTHON_LIBRARY='#{python_prefix}/Python'"

      # Install to lib and let installer symlink to global python site-packages.
      # The path in lib needs to exist first and be listed in PYTHONPATH.
      pydir = lib/which_python/'site-packages'
      pydir.mkpath
      ENV['PYTHONPATH'] = pydir
      args << "-DVTK_PYTHON_SETUP_ARGS:STRING='--prefix=#{prefix} --install-lib=#{pydir} --single-version-externally-managed --record=installed-files.txt'"

      # For Xcode-only systems, the headers of system's python are inside of Xcode
      if !MacOS::CLT.installed? and python_prefix.start_with? '/System/Library'
        args << "-DPYTHON_INCLUDE_DIR='#{MacOS.sdk_path}/System/Library/Frameworks/Python.framework/Versions/2.7/Headers'"
      end
<<<<<<< HEAD
      args << '-DVTK_WRAP_PYTHON=ON'
<<<<<<< HEAD
      if ARGV.include? '--pyqt'
=======
=======

>>>>>>> 35b0414670cc73c4050f911c89fc1602fa6a1d40
      if build.include? 'pyqt'
>>>>>>> 0dba76a6beda38e9e5357faaf3339408dcea0879
        args << '-DVTK_WRAP_PYTHON_SIP=ON'
        args << "-DSIP_PYQT_DIR='#{HOMEBREW_PREFIX}/share/sip'"
      end
    end

<<<<<<< HEAD
    if ARGV.include? '--qt' or ARGV.include? '--qt-extern'
=======
    if build.include? 'qt' or build.include? 'qt-extern'
>>>>>>> 0dba76a6beda38e9e5357faaf3339408dcea0879
      args << '-DVTK_USE_GUISUPPORT=ON'
      args << '-DVTK_USE_QT=ON'
      args << '-DVTK_USE_QVTK=ON'
    end

<<<<<<< HEAD
    args << '-DVTK_WRAP_TCL=ON' if ARGV.include? '--tcl'

    # default to cocoa for everything except x11
    if ARGV.include? '--x11'
=======
    args << '-DVTK_WRAP_TCL=ON' if build.include? 'tcl'

    # Cocoa for everything except x11
    if build.include? 'x11'
>>>>>>> 0dba76a6beda38e9e5357faaf3339408dcea0879
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
<<<<<<< HEAD
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
=======
    end

    (share+'vtk').install 'Examples' if build.include? 'examples'
  end

  def caveats
    s = ''
    vtk = Tab.for_formula 'vtk'
    if build.include? 'python' or vtk.include? 'python'
      s += <<-EOS.undent
        For non-homebrew Python, you need to amend your PYTHONPATH like so:
        export PYTHONPATH=#{HOMEBREW_PREFIX}/lib/#{which_python}/site-packages:$PYTHONPATH

        Even without the --pyqt option, you can display native VTK render windows
        from python. Alternatively, you can integrate the RenderWindowInteractor
        in PyQt, PySide, Tk or Wx at runtime. Look at
            import vtk.qt4; help(vtk.qt4) or import vtk.wx; help(vtk.wx)

      EOS
    end
    if build.include? 'examples' or vtk.include? 'examples'
      s += <<-EOS.undent

        The scripting examples are stored in #{HOMEBREW_PREFIX}/share/vtk

      EOS
    end
>>>>>>> 0dba76a6beda38e9e5357faaf3339408dcea0879
    return s.empty? ? nil : s
  end

  def which_python
    "python" + `python -c 'import sys;print(sys.version[:3])'`.strip
  end
end

__END__
diff --git a/Wrapping/Python/setup_install_paths.py b/Wrapping/Python/setup_install_paths.py
index 00f48c8..014b906 100755
--- a/Wrapping/Python/setup_install_paths.py
+++ b/Wrapping/Python/setup_install_paths.py
@@ -35,7 +35,7 @@ def get_install_path(command, *args):
                 option, value = string.split(arg,"=")
                 options[option] = value
             except ValueError:
-                options[option] = 1
+                options[arg] = 1

     # check for the prefix and exec_prefix
     try:
