require "formula"

class Pypy < Formula
  homepage "http://pypy.org/"
  url "https://bitbucket.org/pypy/pypy/downloads/pypy-2.4.0-src.tar.bz2"
  sha1 "e2e0bcf8457c0ae5a24f126a60aa921dabfe60fb"
  revision 2

  bottle do
    cellar :any
    revision 5
    sha1 "77813b96e04fe46de87532e7177a0ecfe4a84005" => :yosemite
    sha1 "bae7b2be9d770062b582faffdbadb113135b1d57" => :mavericks
    sha1 "cce0ddd2900bd49e4988bcdcdffdf8ee3c51828d" => :mountain_lion
  end

  depends_on :arch => :x86_64
  depends_on "pkg-config" => :build
  depends_on "openssl"

  resource "setuptools" do
    url "https://pypi.python.org/packages/source/s/setuptools/setuptools-8.2.1.tar.gz"
    sha1 "ddb4454303142be3446437e4fafb13bbd4570133"
  end

  resource "pip" do
    url "https://pypi.python.org/packages/source/p/pip/pip-6.0.3.tar.gz"
    sha1 "67d4affd83ee2f3514ac1386bee59f10f672517c"
  end

  # https://bugs.launchpad.net/ubuntu/+source/gcc-4.2/+bug/187391
  fails_with :gcc

  def install
    # Having PYTHONPATH set can cause the build to fail if another
    # Python is present, e.g. a Homebrew-provided Python 2.x
    # See https://github.com/Homebrew/homebrew/issues/24364
    ENV["PYTHONPATH"] = ""
    ENV["PYPY_USESSION_DIR"] = buildpath

    Dir.chdir "pypy/goal" do
      system "python", buildpath/"rpython/bin/rpython",
             "-Ojit", "--shared", "--cc", ENV.cc, "--translation-verbose",
             "--make-jobs", ENV.make_jobs, "targetpypystandalone.py"
      system "install_name_tool", "-change", "libpypy-c.dylib", libexec/"lib/libpypy-c.dylib", "pypy-c"
      system "install_name_tool", "-id", opt_libexec/"lib/libpypy-c.dylib", "libpypy-c.dylib"
      (libexec/"bin").install "pypy-c" => "pypy"
      (libexec/"lib").install "libpypy-c.dylib"
    end

    (libexec/"lib-python").install "lib-python/2.7"
    libexec.install %w[include lib_pypy]

    # The PyPy binary install instructions suggest installing somewhere
    # (like /opt) and symlinking in binaries as needed. Specifically,
    # we want to avoid putting PyPy's Python.h somewhere that configure
    # scripts will find it.
    bin.install_symlink libexec/"bin/pypy"
    lib.install_symlink libexec/"lib/libpypy-c.dylib"
  end

  def post_install
    # Precompile cffi extensions in lib_pypy
    # list from create_cffi_import_libraries in pypy/tool/release/package.py
    %w[_sqlite3 _curses syslog gdbm _tkinter].each do |module_name|
      quiet_system bin/"pypy", "-c", "import #{module_name}"
    end

    # Post-install, fix up the site-packages and install-scripts folders
    # so that user-installed Python software survives minor updates, such
    # as going from 1.7.0 to 1.7.1.

    # Create a site-packages in the prefix.
    prefix_site_packages.mkpath

    # Symlink the prefix site-packages into the cellar.
    libexec.install_symlink prefix_site_packages

    # Tell distutils-based installers where to put scripts
    scripts_folder.mkpath
    (distutils+"distutils.cfg").atomic_write <<-EOF.undent
      [install]
      install-scripts=#{scripts_folder}
    EOF

    resource("setuptools").stage { system "#{libexec}/bin/pypy", "setup.py", "install" }
    resource("pip").stage { system "#{libexec}/bin/pypy", "setup.py", "install" }

    # Symlinks to easy_install_pypy and pip_pypy
    bin.install_symlink scripts_folder/"easy_install" => "easy_install_pypy"
    bin.install_symlink scripts_folder/"pip" => "pip_pypy"

    # post_install happens after linking
    %w[easy_install_pypy pip_pypy].each { |e| (HOMEBREW_PREFIX/"bin").install_symlink bin/e }
  end

  def caveats; <<-EOS.undent
    A "distutils.cfg" has been written to:
      #{distutils}
    specifying the install-scripts folder as:
      #{scripts_folder}

    If you install Python packages via "pypy setup.py install", easy_install_pypy,
    or pip_pypy, any provided scripts will go into the install-scripts folder
    above, so you may want to add it to your PATH *after* #{HOMEBREW_PREFIX}/bin
    so you don't overwrite tools from CPython.

    Setuptools and pip have been installed, so you can use easy_install_pypy and
    pip_pypy.
    To update setuptools and pip between pypy releases, run:
        #{scripts_folder}/pip install --upgrade setuptools

    See: https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Homebrew-and-Python.md
    EOS
  end

  # The HOMEBREW_PREFIX location of site-packages
  def prefix_site_packages
    HOMEBREW_PREFIX+"lib/pypy/site-packages"
  end

  # Where setuptools will install executable scripts
  def scripts_folder
    HOMEBREW_PREFIX+"share/pypy"
  end

  # The Cellar location of distutils
  def distutils
    libexec+"lib-python/2.7/distutils"
  end
end
