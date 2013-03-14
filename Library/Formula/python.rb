require 'formula'

class Distribute < Formula
  url 'https://pypi.python.org/packages/source/d/distribute/distribute-0.6.35.tar.gz'
  sha1 'a928104ea1bd1f85c35de6d0d5f1628d2602ac66'
end

class Pip < Formula
  url 'https://pypi.python.org/packages/source/p/pip/pip-1.3.1.tar.gz'
  sha1 '9c70d314e5dea6f41415af814056b0f63c3ffd14'
end

class Python < Formula
  homepage 'http://www.python.org'
  url 'http://www.python.org/ftp/python/2.7.3/Python-2.7.3.tar.bz2'
  sha1 '842c4e2aff3f016feea3c6e992c7fa96e49c9aa0'

  option :universal
  option 'quicktest', 'Run `make quicktest` after the build'
  option 'with-brewed-openssl', "Use Homebrew's openSSL instead of the one from OS X"
  option 'with-brewed-tk', "Use Homebrew's Tk (has optional Cocoa and threads support)"
  option 'with-poll', 'Enable select.poll, which is not fully implemented on OS X (http://bugs.python.org/issue5154)'
  # --with-dtrace relies on CLT as dtrace hard-codes paths to /usr
  option 'with-dtrace', 'Experimental DTrace support (http://bugs.python.org/issue13405)' if MacOS::CLT.installed?

  depends_on 'pkg-config' => :build
  depends_on 'readline' => :recommended
  depends_on 'sqlite' => :recommended
  depends_on 'gdbm' => :recommended
  depends_on 'openssl' if build.include? 'with-brewed-openssl'
  depends_on 'homebrew/dupes/tk' if build.include? 'with-brewed-tk'

  def patches
    p = []
    # python fails to build on NFS; patch is merged upstream, will be in next release
    # see http://bugs.python.org/issue14662
    p << "https://gist.github.com/raw/4349132/25662c6b382315b5db67bf949773d76471bbcee7/python-nfs-shutil.diff"
    p << 'https://raw.github.com/gist/3415636/2365dea8dc5415daa0148e98c394345e1191e4aa/pythondtrace-patch.diff' if build.include? 'with-dtrace'
    # Patch to disable the search for Tk.frameworked, since homebrew's Tk is a plain unix build
    p << DATA if build.include? 'with-brewed-tk'
    p
  end

  def site_packages_cellar
    prefix/"Frameworks/Python.framework/Versions/2.7/lib/python2.7/site-packages"
  end

  # The HOMEBREW_PREFIX location of site-packages.
  def site_packages
    HOMEBREW_PREFIX/"lib/python2.7/site-packages"
  end

  # Where distribute/pip will install executable scripts.
  def scripts_folder
    HOMEBREW_PREFIX/"share/python"
  end

  def install
    opoo 'The given option --with-poll enables a somewhat broken poll() on OS X (http://bugs.python.org/issue5154).' if build.include? 'with-poll'

    # Unset these so that installing pip and distribute puts them where we want
    # and not into some other Python the user has installed.
    ENV['PYTHONPATH'] = nil
    ENV['PYTHONHOME'] = nil

    args = %W[
             --prefix=#{prefix}
             --enable-ipv6
             --datarootdir=#{share}
             --datadir=#{share}
             --enable-framework=#{prefix}/Frameworks
           ]

    args << '--without-gcc' if ENV.compiler == :clang
    args << '--with-dtrace' if build.include? 'with-dtrace'

    if superenv?
      distutils_fix_superenv(args)
    else
      distutils_fix_stdenv
    end

    if build.universal?
      ENV.universal_binary
      args << "--enable-universalsdk=/" << "--with-universal-archs=intel"
    end

    # Allow sqlite3 module to load extensions: http://docs.python.org/library/sqlite3.html#f1
    inreplace "setup.py", 'sqlite_defines.append(("SQLITE_OMIT_LOAD_EXTENSION", "1"))', ''

    system "./configure", *args

    # HAVE_POLL is "broken" on OS X
    # See: http://trac.macports.org/ticket/18376 and http://bugs.python.org/issue5154
    inreplace 'pyconfig.h', /.*?(HAVE_POLL[_A-Z]*).*/, '#undef \1' unless build.include? "with-poll"

    system "make"

    ENV.deparallelize # Installs must be serialized
    # Tell Python not to install into /Applications (default for framework builds)
    system "make", "install", "PYTHONAPPSDIR=#{prefix}"
    # Demos and Tools
    (HOMEBREW_PREFIX/'share/python').mkpath
    system "make", "frameworkinstallextras", "PYTHONAPPSDIR=#{share}/python"
    system "make", "quicktest" if build.include? 'quicktest'

    # Post-install, fix up the site-packages and install-scripts folders
    # so that user-installed Python software survives minor updates, such
    # as going from 2.7.0 to 2.7.1:

    # Remove the site-packages that Python created in its Cellar.
    site_packages_cellar.rmtree
    # Create a site-packages in HOMEBREW_PREFIX/lib/python/site-packages
    site_packages.mkpath
    # Symlink the prefix site-packages into the cellar.
    ln_s site_packages, site_packages_cellar

    # Teach python not to use things from /System
    # and tell it about the correct site-package dir because we moved it
    sitecustomize = site_packages_cellar/"sitecustomize.py"
    rm sitecustomize if File.exist? sitecustomize
    sitecustomize.write <<-EOF.undent
      # This file is created by `brew install python` and is executed on each
      # python startup. Don't print from here, or else universe will collapse.
      import sys
      import site

      # Only do fix 1 and 2, if the currently run python is a brewed one.
      if sys.executable.startswith('#{HOMEBREW_PREFIX}'):
          # Fix 1)
          #   A setuptools.pth and/or easy-install.pth sitting either in
          #   /Library/Python/2.7/site-packages or in
          #   ~/Library/Python/2.7/site-packages can inject the
          #   /System's Python site-packages. People then report
          #   "OSError: [Errno 13] Permission denied" because pip/easy_install
          #   attempts to install into
          #   /System/Library/Frameworks/Python.framework/Versions/2.7/Extras/lib/python
          #   See: https://github.com/mxcl/homebrew/issues/14712
          sys.path = [ p for p in sys.path if not p.startswith('/System') ]

          # Fix 2)
          #   Remove brewed Python's hard-coded site-packages
          sys.path.remove('#{site_packages_cellar}')

      # Fix 3)
      #   For all Pythons: Tell about homebrew's site-packages location.
      #   This is needed for Python to parse *.pth files.
      site.addsitedir('#{site_packages}')
    EOF

    # Install distribute and pip
    # It's important to have these installers in our bin, because some users
    # forget to put #{script_folder} in PATH, then easy_install'ing
    # into /Library/Python/X.Y/site-packages with /usr/bin/easy_install.
    mkdir_p scripts_folder unless scripts_folder.exist?
    setup_args = ["-s", "setup.py", "--no-user-cfg", "install", "--force", "--verbose", "--install-lib=#{site_packages_cellar}", "--install-scripts=#{bin}"]
    Distribute.new.brew { system "#{bin}/python", *setup_args }
    Pip.new.brew { system "#{bin}/python", *setup_args }

    # Tell distutils-based installers where to put scripts and python modules
    (prefix/"Frameworks/Python.framework/Versions/2.7/lib/python2.7/distutils/distutils.cfg").write <<-EOF.undent
      [install]
      install-scripts=#{scripts_folder}
      install-lib=#{site_packages}
    EOF

    makefile = prefix/'Frameworks/Python.framework/Versions/2.7/lib/python2.7/config/Makefile'
    inreplace makefile do |s|
      unless MacOS::CLT.installed?
        s.gsub!(/^CC=.*$/, "CC=xcrun clang")
        s.gsub!(/^CXX=.*$/, "CXX=xcrun clang++")
        s.gsub!(/^AR=.*$/, "AR=xcrun ar")
        s.gsub!(/^RANLIB=.*$/, "RANLIB=xcrun ranlib")
      end
      # Should be fixed regardless of CLT (for `python-config --ldflags`)
      s.gsub!(/^PYTHONFRAMEWORKDIR=\tPython\.framework/, "PYTHONFRAMEWORKDIR= #{opt_prefix}/Frameworks/Python.framework")
    end

  end

  def distutils_fix_superenv(args)
    # To allow certain Python bindings to find brewed software:
    cflags = "CFLAGS=-I#{HOMEBREW_PREFIX}/include -I#{Formula.factory('sqlite').opt_prefix}/include"
    ldflags = "LDFLAGS=-L#{HOMEBREW_PREFIX}/lib -L#{Formula.factory('sqlite').opt_prefix}/lib"
    unless MacOS::CLT.installed?
      # Help Python's build system (distribute/pip) to build things on Xcode-only systems
      # The setup.py looks at "-isysroot" to get the sysroot (and not at --sysroot)
      cflags += " -isysroot #{MacOS.sdk_path}"
      ldflags += " -isysroot #{MacOS.sdk_path}"
      # Same zlib.h-not-found-bug as in env :std (see below)
      args << "CPPFLAGS=-I#{MacOS.sdk_path}/usr/include"
      # For the Xlib.h, Python needs this header dir with the system Tk
      unless build.include? 'with-brewed-tk'
        cflags += " -I#{MacOS.sdk_path}/System/Library/Frameworks/Tk.framework/Versions/8.5/Headers"
      end
    end
    args << cflags
    args << ldflags
    # Avoid linking to libgcc http://code.activestate.com/lists/python-dev/112195/
    args << "MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}"
    # We want our readline! This is just to outsmart the detection code,
    # superenv handles that cc finds includes/libs!
    inreplace "setup.py",
              "do_readline = self.compiler.find_library_file(lib_dirs, 'readline')",
              "do_readline = '#{HOMEBREW_PREFIX}/opt/readline/lib/libhistory.dylib'"
  end

  def distutils_fix_stdenv()
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
    # "whether gcc supports ParseTuple" (https://github.com/mxcl/homebrew/issues/12194)
    ENV.enable_warnings
    if ENV.compiler == :clang
      # http://docs.python.org/devguide/setup.html#id8 suggests to disable some Warnings.
      ENV.append_to_cflags '-Wno-unused-value'
      ENV.append_to_cflags '-Wno-empty-body'
      ENV.append_to_cflags '-Qunused-arguments'
    end
  end

  def caveats
    <<-EOS.undent
      Homebrew's Python framework
        #{prefix}/Frameworks/Python.framework

      Python demo
        #{HOMEBREW_PREFIX}/share/python/Extras

      Distribute and Pip have been installed. To update them
        pip install --upgrade distribute
        pip install --upgrade pip

      To symlink "Idle" and the "Python Launcher" to ~/Applications
        `brew linkapps`

      You can install Python packages with (the outdated easy_install or)
        `pip install <your_favorite_package>`

      They will install into the site-package directory
        #{site_packages}

      Executable python scripts will be put in:
        #{scripts_folder}
      so you may want to put "#{scripts_folder}" in your PATH, too.

      See: https://github.com/mxcl/homebrew/wiki/Homebrew-and-Python
    EOS
  end

  def test
    # Check if sqlite is ok, because we build with --enable-loadable-sqlite-extensions
    # and it can occur that building sqlite silently fails if OSX's sqlite is used.
    system "#{bin}/python", "-c", "import sqlite3"
    # Check if some other modules import. Then the linked libs are working.
    system "#{bin}/python", "-c", "import Tkinter; root = Tkinter.Tk()"
  end
end

__END__
diff --git a/setup.py b/setup.py
index 6b47451..b0400f8 100644
--- a/setup.py
+++ b/setup.py
@@ -1702,9 +1702,9 @@ class PyBuildExt(build_ext):
         # AquaTk is a separate method. Only one Tkinter will be built on
         # Darwin - either AquaTk, if it is found, or X11 based Tk.
         platform = self.get_platform()
-        if (platform == 'darwin' and
-            self.detect_tkinter_darwin(inc_dirs, lib_dirs)):
-            return
+        # if (platform == 'darwin' and
+        #     self.detect_tkinter_darwin(inc_dirs, lib_dirs)):
+        #     return

         # Assume we haven't found any of the libraries or include files
         # The versions with dots are used on Unix, and the versions without
