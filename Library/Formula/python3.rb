require 'formula'
require Formula.path("python") # For TkCheck requirement

# Python3 is the new language standard, not just a new revision.
# It's somewhat incompatible to Python 2.x, therefore, the executable
# "python" will always point to the 2.x version which you can get by
# `brew install python`.

class Distribute < Formula
  url 'http://pypi.python.org/packages/source/d/distribute/distribute-0.6.28.tar.gz'
  md5 'b400b532e33f78551e6847c1f5965e56'
end

# Recommended way of installing python modules (http://pypi.python.org/pypi)
class Pip < Formula
  url 'http://pypi.python.org/packages/source/p/pip/pip-1.1.tar.gz'
  md5 '62a9f08dd5dc69d76734568a6c040508'
end

class Python3 < Formula
  homepage 'http://www.python.org/'
  url 'http://python.org/ftp/python/3.2.3/Python-3.2.3.tar.bz2'
  md5 'cea34079aeb2e21e7b60ee82a0ac286b'

  depends_on TkCheck.new
  depends_on 'pkg-config' => :build
  depends_on 'readline' => :optional  # Prefer over OS X's libedit
  depends_on 'sqlite'   => :optional  # Prefer over OS X's older version
  depends_on 'gdbm'     => :optional
  depends_on :x11 # tk.h includes X11/Xlib.h and X11/X.h

  option 'quicktest', 'Run `make quicktest` after the build'

  # Skip binaries so modules will load; skip lib because it is mostly Python files
  skip_clean ['bin', 'lib']

  def site_packages_cellar
    prefix/"Frameworks/Python.framework/Versions/3.2/lib/python3.2/site-packages"
  end

  # The HOMEBREW_PREFIX location of site-packages.
  def site_packages
    HOMEBREW_PREFIX/"lib/python3.2/site-packages"
  end

  # Where distribute/pip will install executable scripts.
  def scripts_folder
    HOMEBREW_PREFIX/"share/python3"
  end

  def effective_lib
    prefix/"Frameworks/Python.framework/Versions/3.2/lib"
  end

  def install
    args = %W[--prefix=#{prefix}
             --enable-ipv6
             --datarootdir=#{share}
             --datadir=#{share}
             --enable-framework=#{prefix}/Frameworks
           ]

    args << '--without-gcc' if ENV.compiler == :clang

    # Don't use optimizations other than "-Os" here, because Python's distutils
    # remembers (hint: `python-config --cflags`) and reuses them for C
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
    end

    # Allow sqlite3 module to load extensions:
    # http://docs.python.org/library/sqlite3.html#f1
    inreplace "setup.py", 'sqlite_defines.append(("SQLITE_OMIT_LOAD_EXTENSION", "1"))', 'pass'

    system "./configure", *args
    system "make"
    ENV.deparallelize # Installs must be serialized
    # Tell Python not to install into /Applications (default for framework builds)
    system "make", "install", "PYTHONAPPSDIR=#{prefix}"
    system "make", "quicktest" if build.include? "quicktest"

    # Any .app get a " 3" attached, so it does not conflict with python 2.x.
    Dir.glob(prefix/"*.app").each do |app|
      mv app, app.gsub(".app", " 3.app")
    end

    # Post-install, fix up the site-packages and install-scripts folders
    # so that user-installed Python software survives minor updates, such
    # as going from 3.2.2 to 3.2.3.

    # Remove the site-packages that Python created in its Cellar.
    site_packages_cellar.rmtree
    # Create a site-packages in HOMEBREW_PREFIX/lib/python3/site-packages
    site_packages.mkpath
    # Symlink the prefix site-packages into the cellar.
    ln_s site_packages, site_packages_cellar

    # "python3" and executable is forgotten for framework builds.
    # Make sure homebrew symlinks it to HOMEBREW_PREFIX/bin.
    ln_s "#{bin}/python3.2", "#{bin}/python3" unless (bin/"python3").exist?

    # Tell distutils-based installers where to put scripts
    scripts_folder.mkpath
    (effective_lib/"python3.2/distutils/distutils.cfg").write <<-EOF.undent
      [install]
      install-scripts=#{scripts_folder}
    EOF

    # Install distribute for python3
    Distribute.new.brew do
      system "#{bin}/python3.2", "setup.py", "install"
      # Symlink to easy_install3 to match python3 command.
      unless (scripts_folder/'easy_install3').exist?
        ln_s scripts_folder/"easy_install", scripts_folder/"easy_install3"
      end
    end
    # Install pip-3.2 for python3
    Pip.new.brew { system "#{bin}/python3.2", "setup.py", "install" }
  end

  def caveats
    text = <<-EOS.undent
      The Python framework is located at:
        #{prefix}/Frameworks/Python.framework

      You can `brew linkapps` to symlink "Idle 3" and the "Python Launcher 3".
    EOS

    # Tk warning only for 10.6
    tk_caveats = <<-EOS.undent

      Apple's Tcl/Tk is not recommended for use with Python on Mac OS X 10.6.
      For more information see: http://www.python.org/download/mac/tcltk/
    EOS

    general_caveats = <<-EOS.undent

      A "distutils.cfg" has been written, specifying the install-scripts directory as:
        #{scripts_folder}

      If you install Python packages via "pip-3.2 install x" or "python3 setup.py install"
      (or the outdated easy_install3), any provided scripts will go into the
      install-scripts folder above, so you may want to add it to your PATH.

      The site-package directory for brewed Python:
        #{site_packages}

      Distribute and Pip have been installed. To update them:
      #{scripts_folder}/pip-3.2 install --upgrade distribute
      #{scripts_folder}/pip-3.2 install --upgrade pip

      See: https://github.com/mxcl/homebrew/wiki/Homebrew-and-Python
    EOS

    text += tk_caveats unless MacOS.version >= :lion
    text += general_caveats
    return text
  end

  def test
    # Check if sqlite is ok, because we build with --enable-loadable-sqlite-extensions
    # and it can occur that building sqlite silently fails.
    system "#{bin}/python3", "-c", "import sqlite3"
    # See: https://github.com/mxcl/homebrew/pull/10487
    # Fixed [upstream](http://bugs.python.org/issue11149), but still nice to have.
    `#{bin}/python3 -c 'from decimal import Decimal; print(Decimal(4) / Decimal(2))'`.chomp == '2'
  end
end
