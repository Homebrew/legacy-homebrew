require 'formula'

class Python3 < Formula
  homepage 'https://www.python.org/'
  url 'https://python.org/ftp/python/3.4.1/Python-3.4.1.tgz'
  sha1 'e8c1bd575a6ccc2a75f79d9d094a6a29d3802f5d'

  bottle do
    sha1 "e86f7aede6e519a426e326f5020dc780ee39f05e" => :mavericks
    sha1 "ad0bdc7fbf3f5079d134405fc83465634e07c40d" => :mountain_lion
    sha1 "942f16fe68c47b267c958eca67f3754b412bd10d" => :lion
  end

  VER='3.4'  # The <major>.<minor> is used so often.

  head 'http://hg.python.org/cpython', :using => :hg, :branch => VER

  option :universal
  option 'quicktest', 'Run `make quicktest` after the build'
  option 'with-brewed-tk', "Use Homebrew's Tk (has optional Cocoa and threads support)"

  depends_on 'pkg-config' => :build
  depends_on 'readline' => :recommended
  depends_on 'sqlite' => :recommended
  depends_on 'gdbm' => :recommended
  depends_on 'openssl'
  depends_on 'xz' => :recommended  # for the lzma module added in 3.3
  depends_on 'homebrew/dupes/tcl-tk' if build.with? 'brewed-tk'
  depends_on :x11 if build.with? "brewed-tk" and Tab.for_name("tcl-tk").with? "x11"

  skip_clean "bin/pip3", "bin/pip-#{VER}"
  skip_clean "bin/easy_install3", "bin/easy_install-#{VER}"

  patch :DATA if build.with? 'brewed-tk'

  def site_packages_cellar
    prefix/"Frameworks/Python.framework/Versions/#{VER}/lib/python#{VER}/site-packages"
  end

  # The HOMEBREW_PREFIX location of site-packages.
  def site_packages
    HOMEBREW_PREFIX/"lib/python#{VER}/site-packages"
  end

  fails_with :llvm do
    build 2336
    cause <<-EOS.undent
      Could not find platform dependent libraries <exec_prefix>
      Consider setting $PYTHONHOME to <prefix>[:<exec_prefix>]
      python.exe(14122) malloc: *** mmap(size=7310873954244194304) failed (error code=12)
      *** error: can't allocate region
      *** set a breakpoint in malloc_error_break to debug
      Could not import runpy module
      make: *** [pybuilddir.txt] Segmentation fault: 11
    EOS
  end

  # setuptools remembers the build flags python is built with and uses them to
  # build packages later. Xcode-only systems need different flags.
  def pour_bottle?
    MacOS::CLT.installed?
  end

  def install
    # Unset these so that installing pip and setuptools puts them where we want
    # and not into some other Python the user has installed.
    ENV['PYTHONHOME'] = nil
    ENV['PYTHONPATH'] = nil

    args = %W[
      --prefix=#{prefix}
      --enable-ipv6
      --datarootdir=#{share}
      --datadir=#{share}
      --enable-framework=#{frameworks}
    ]

    args << '--without-gcc' if ENV.compiler == :clang

    if superenv?
      distutils_fix_superenv(args)
    else
      distutils_fix_stdenv
    end

    if build.universal?
      ENV.universal_binary
      args << "--enable-universalsdk" << "--with-universal-archs=intel"
    end

    # Allow sqlite3 module to load extensions: http://docs.python.org/library/sqlite3.html#f1
    inreplace("setup.py", 'sqlite_defines.append(("SQLITE_OMIT_LOAD_EXTENSION", "1"))', 'pass') if build.with? 'sqlite'

    # Allow python modules to use ctypes.find_library to find homebrew's stuff
    # even if homebrew is not a /usr/local/lib. Try this with:
    # `brew install enchant && pip install pyenchant`
    inreplace "./Lib/ctypes/macholib/dyld.py" do |f|
      f.gsub! 'DEFAULT_LIBRARY_FALLBACK = [', "DEFAULT_LIBRARY_FALLBACK = [ '#{HOMEBREW_PREFIX}/lib',"
      f.gsub! 'DEFAULT_FRAMEWORK_FALLBACK = [', "DEFAULT_FRAMEWORK_FALLBACK = [ '#{HOMEBREW_PREFIX}/Frameworks',"
    end

    if build.with? 'brewed-tk'
      tcl_tk = Formula["tcl-tk"].opt_prefix
      ENV.append 'CPPFLAGS', "-I#{tcl_tk}/include"
      ENV.append 'LDFLAGS', "-L#{tcl_tk}/lib"
    end

    system "./configure", *args

    system "make"

    ENV.deparallelize # Installs must be serialized
    # Tell Python not to install into /Applications (default for framework builds)
    system "make", "install", "PYTHONAPPSDIR=#{prefix}"
    # Demos and Tools
    system "make", "frameworkinstallextras", "PYTHONAPPSDIR=#{share}/python3"
    system "make", "quicktest" if build.include? "quicktest"

    # Any .app get a " 3" attached, so it does not conflict with python 2.x.
    Dir.glob("#{prefix}/*.app") { |app| mv app, app.sub(".app", " 3.app") }

    # A fix, because python and python3 both want to install Python.framework
    # and therefore we can't link both into HOMEBREW_PREFIX/Frameworks
    # https://github.com/Homebrew/homebrew/issues/15943
    ["Headers", "Python", "Resources"].each{ |f| rm(prefix/"Frameworks/Python.framework/#{f}") }
    rm prefix/"Frameworks/Python.framework/Versions/Current"

    # Remove 2to3 because python2 also installs it
    rm bin/"2to3"

    # Remove the site-packages that Python created in its Cellar.
    site_packages_cellar.rmtree
  end

  def post_install
    # Fix up the site-packages so that user-installed Python software survives
    # minor updates, such as going from 3.3.2 to 3.3.3:

    # Create a site-packages in HOMEBREW_PREFIX/lib/python#{VER}/site-packages
    site_packages.mkpath

    # Symlink the prefix site-packages into the cellar.
    site_packages_cellar.unlink if site_packages_cellar.exist?
    site_packages_cellar.parent.install_symlink site_packages

    # Write our sitecustomize.py
    rm_rf Dir["#{site_packages}/sitecustomize.py[co]"]
    (site_packages/"sitecustomize.py").atomic_write(sitecustomize)

    # Remove old setuptools installations that may still fly around and be
    # listed in the easy_install.pth. This can break setuptools build with
    # zipimport.ZipImportError: bad local file header
    # setuptools-0.9.8-py3.3.egg
    rm_rf Dir["#{site_packages}/setuptools*"]
    rm_rf Dir["#{site_packages}/distribute*"]

    # Install the bundled pip if it's newer than the installed version
    system bin/"python3", "-m", "ensurepip", "--upgrade"

    # And now we write the distutils.cfg
    cfg = prefix/"Frameworks/Python.framework/Versions/#{VER}/lib/python#{VER}/distutils/distutils.cfg"
    cfg.atomic_write <<-EOF.undent
      [global]
      verbose=1
      [install]
      prefix=#{HOMEBREW_PREFIX}
    EOF
  end

  def distutils_fix_superenv(args)
    # To allow certain Python bindings to find brewed software (and sqlite):
    sqlite = Formula["sqlite"].opt_prefix
    cflags = "CFLAGS=-I#{HOMEBREW_PREFIX}/include -I#{sqlite}/include"
    ldflags = "LDFLAGS=-L#{HOMEBREW_PREFIX}/lib -L#{sqlite}/lib"
    unless MacOS::CLT.installed?
      # Help Python's build system (setuptools/pip) to build things on Xcode-only systems
      # The setup.py looks at "-isysroot" to get the sysroot (and not at --sysroot)
      cflags += " -isysroot #{MacOS.sdk_path}"
      ldflags += " -isysroot #{MacOS.sdk_path}"
      # Same zlib.h-not-found-bug as in env :std (see below)
      args << "CPPFLAGS=-I#{MacOS.sdk_path}/usr/include"
      if build.without? 'brewed-tk'
        cflags += " -I#{MacOS.sdk_path}/System/Library/Frameworks/Tk.framework/Versions/8.5/Headers"
      end
    end
    args << cflags
    args << ldflags
    # Avoid linking to libgcc http://code.activestate.com/lists/python-dev/112195/
    args << "MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}"
    # We want our readline! This is just to outsmart the detection code,
    # superenv makes cc always find includes/libs!
    inreplace "setup.py",
              "do_readline = self.compiler.find_library_file(lib_dirs, 'readline')",
              "do_readline = '#{HOMEBREW_PREFIX}/opt/readline/lib/libhistory.dylib'"
  end

  def distutils_fix_stdenv
    # Python scans all "-I" dirs but not "-isysroot", so we add
    # the needed includes with "-I" here to avoid this err:
    #     building dbm using ndbm
    #     error: /usr/include/zlib.h: No such file or directory
    ENV.append 'CPPFLAGS', "-I#{MacOS.sdk_path}/usr/include" unless MacOS::CLT.installed?

    # Don't use optimizations other than "-Os" here, because Python's distutils
    # remembers (hint: `python3-config --cflags`) and reuses them for C
    # extensions which can break software (such as scipy 0.11 fails when
    # "-msse4" is present.)
    ENV.minimal_optimization

    # We need to enable warnings because the configure.in uses -Werror to detect
    # "whether gcc supports ParseTuple" (https://github.com/Homebrew/homebrew/issues/12194)
    ENV.enable_warnings
    if ENV.compiler == :clang
      # http://docs.python.org/devguide/setup.html#id8 suggests to disable some Warnings.
      ENV.append_to_cflags '-Wno-unused-value'
      ENV.append_to_cflags '-Wno-empty-body'
    end
  end

  def sitecustomize
    <<-EOF.undent
      # This file is created by Homebrew and is executed on each python startup.
      # Don't print from here, or else python command line scripts may fail!
      # <https://github.com/Homebrew/homebrew/wiki/Homebrew-and-Python>
      import os
      import sys

      if sys.version_info[0] != 3:
          # This can only happen if the user has set the PYTHONPATH for 3.x and run Python 2.x or vice versa.
          # Every Python looks at the PYTHONPATH variable and we can't fix it here in sitecustomize.py,
          # because the PYTHONPATH is evaluated after the sitecustomize.py. Many modules (e.g. PyQt4) are
          # built only for a specific version of Python and will fail with cryptic error messages.
          # In the end this means: Don't set the PYTHONPATH permanently if you use different Python versions.
          exit('Your PYTHONPATH points to a site-packages dir for Python 3.x but you are running Python ' +
               str(sys.version_info[0]) + '.x!\\n     PYTHONPATH is currently: "' + str(os.environ['PYTHONPATH']) + '"\\n' +
               '     You should `unset PYTHONPATH` to fix this.')
      else:
          # Only do this for a brewed python:
          opt_executable = '#{opt_bin}/python#{VER}'
          if os.path.realpath(sys.executable) == os.path.realpath(opt_executable):
              # Remove /System site-packages, and the Cellar site-packages
              # which we moved to lib/pythonX.Y/site-packages. Further, remove
              # HOMEBREW_PREFIX/lib/python because we later addsitedir(...).
              sys.path = [ p for p in sys.path
                           if (not p.startswith('/System') and
                               not p.startswith('#{HOMEBREW_PREFIX}/lib/python') and
                               not (p.startswith('#{rack}') and p.endswith('site-packages'))) ]

              # LINKFORSHARED (and python-config --ldflags) return the
              # full path to the lib (yes, "Python" is actually the lib, not a
              # dir) so that third-party software does not need to add the
              # -F/#{HOMEBREW_PREFIX}/Frameworks switch.
              # Assume Framework style build (default since months in brew)
              try:
                  from _sysconfigdata import build_time_vars
                  build_time_vars['LINKFORSHARED'] = '-u _PyMac_Error #{opt_prefix}/Frameworks/Python.framework/Versions/#{VER}/Python'
              except:
                  pass  # remember: don't print here. Better to fail silently.

              # Set the sys.executable to use the opt_prefix
              sys.executable = opt_executable

          # Tell about homebrew's site-packages location.
          # This is needed for Python to parse *.pth.
          import site
          site.addsitedir('#{site_packages}')
    EOF
  end

  def caveats
    text = <<-EOS.undent
      Pip has been installed. To update it
        pip3 install --upgrade pip

      You can install Python packages with
        pip3 install <package>

      They will install into the site-package directory
        #{site_packages}

      See: https://github.com/Homebrew/homebrew/wiki/Homebrew-and-Python
    EOS

    # Tk warning only for 10.6
    tk_caveats = <<-EOS.undent

      Apple's Tcl/Tk is not recommended for use with Python on Mac OS X 10.6.
      For more information see: http://www.python.org/download/mac/tcltk/
    EOS

    text += tk_caveats unless MacOS.version >= :lion
    return text
  end

  test do
    # Check if sqlite is ok, because we build with --enable-loadable-sqlite-extensions
    # and it can occur that building sqlite silently fails if OSX's sqlite is used.
    system "#{bin}/python#{VER}", "-c", "import sqlite3"
    # Check if some other modules import. Then the linked libs are working.
    system "#{bin}/python#{VER}", "-c", "import tkinter; root = tkinter.Tk()"
  end
end

__END__
# Homebrew's tcl-tk is build in a standard unix fashion (due to link errors)
# and we have to stop python from searching for frameworks and link against
# X11.

diff --git a/setup.py b/setup.py
index d4183d4..9f69520 100644
--- a/setup.py
+++ b/setup.py
@@ -1623,9 +1623,6 @@ class PyBuildExt(build_ext):
         # Rather than complicate the code below, detecting and building
         # AquaTk is a separate method. Only one Tkinter will be built on
         # Darwin - either AquaTk, if it is found, or X11 based Tk.
-        if (host_platform == 'darwin' and
-            self.detect_tkinter_darwin(inc_dirs, lib_dirs)):
-            return

         # Assume we haven't found any of the libraries or include files
         # The versions with dots are used on Unix, and the versions without
@@ -1671,21 +1668,6 @@ class PyBuildExt(build_ext):
             if dir not in include_dirs:
                 include_dirs.append(dir)

-        # Check for various platform-specific directories
-        if host_platform == 'sunos5':
-            include_dirs.append('/usr/openwin/include')
-            added_lib_dirs.append('/usr/openwin/lib')
-        elif os.path.exists('/usr/X11R6/include'):
-            include_dirs.append('/usr/X11R6/include')
-            added_lib_dirs.append('/usr/X11R6/lib64')
-            added_lib_dirs.append('/usr/X11R6/lib')
-        elif os.path.exists('/usr/X11R5/include'):
-            include_dirs.append('/usr/X11R5/include')
-            added_lib_dirs.append('/usr/X11R5/lib')
-        else:
-            # Assume default location for X11
-            include_dirs.append('/usr/X11/include')
-            added_lib_dirs.append('/usr/X11/lib')

         # If Cygwin, then verify that X is installed before proceeding
         if host_platform == 'cygwin':
@@ -1710,10 +1692,6 @@ class PyBuildExt(build_ext):
         if host_platform in ['aix3', 'aix4']:
             libs.append('ld')

-        # Finally, link with the X11 libraries (not appropriate on cygwin)
-        if host_platform != "cygwin":
-            libs.append('X11')
-
         ext = Extension('_tkinter', ['_tkinter.c', 'tkappinit.c'],
                         define_macros=[('WITH_APPINIT', 1)] + defs,
                         include_dirs = include_dirs,
