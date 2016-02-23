class Pypy3 < Formula
  desc "Implementation of Python 3 in Python"
  homepage "http://pypy.org/"
  url "https://bitbucket.org/pypy/pypy/downloads/pypy3-2.4.0-src.tar.bz2"
  sha256 "d9ba207d6eecf8a0dc4414e9f4e92db1abd143e8cc6ec4a6bdcac75b29f104f3"

  bottle do
    cellar :any
    revision 6
    sha256 "7fb0a8af405c03fda611ca3c30c9fda4da2fa727a4c37450fde428c5cb469471" => :el_capitan
    sha256 "91733ffc891b16074fc06b0cdb3446070acf12cdf81475dca8afd2d2decbb4f0" => :yosemite
    sha256 "fc8586a9aea45c5da1a899978cbc3d8b7a359801671caad55dd5c2255fcb538a" => :mavericks
    sha256 "71d8d4319969feb8969e62a4ed4592e7779058c1cb7bcf9c3d506ea39d135ebf" => :mountain_lion
  end

  depends_on :arch => :x86_64
  depends_on "pkg-config" => :build
  depends_on "openssl"

  resource "setuptools" do
    url "https://pypi.python.org/packages/source/s/setuptools/setuptools-19.4.tar.gz"
    sha256 "214bf29933f47cf25e6faa569f710731728a07a19cae91ea64f826051f68a8cf"
  end

  resource "pip" do
    url "https://pypi.python.org/packages/source/p/pip/pip-8.0.2.tar.gz"
    sha256 "46f4bd0d8dfd51125a554568d646fe4200a3c2c6c36b9f2d06d2212148439521"
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
      system "install_name_tool", "-change", "libpypy-c.dylib", libexec/"lib/libpypy3-c.dylib", "pypy-c"
      system "install_name_tool", "-id", opt_libexec/"lib/libpypy3-c.dylib", "libpypy-c.dylib"
      (libexec/"bin").install "pypy-c" => "pypy"
      (libexec/"lib").install "libpypy-c.dylib" => "libpypy3-c.dylib"
    end

    (libexec/"lib-python").install "lib-python/3"
    libexec.install %w[include lib_pypy]

    # The PyPy binary install instructions suggest installing somewhere
    # (like /opt) and symlinking in binaries as needed. Specifically,
    # we want to avoid putting PyPy's Python.h somewhere that configure
    # scripts will find it.
    bin.install_symlink libexec/"bin/pypy" => "pypy3"
    lib.install_symlink libexec/"lib/libpypy3-c.dylib"
  end

  def post_install
    # Precompile cffi extensions in lib_pypy
    # list from create_cffi_import_libraries in pypy/tool/release/package.py
    %w[_sqlite3 _curses syslog gdbm _tkinter].each do |module_name|
      quiet_system bin/"pypy3", "-c", "import #{module_name}"
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

    %w[setuptools pip].each do |pkg|
      resource(pkg).stage do
        system bin/"pypy3", "-s", "setup.py", "install", "--force", "--verbose"
      end
    end

    # Symlinks to easy_install_pypy3 and pip_pypy3
    bin.install_symlink scripts_folder/"easy_install" => "easy_install_pypy3"
    bin.install_symlink scripts_folder/"pip" => "pip_pypy3"

    # post_install happens after linking
    %w[easy_install_pypy3 pip_pypy3].each { |e| (HOMEBREW_PREFIX/"bin").install_symlink bin/e }
  end

  def caveats; <<-EOS.undent
    A "distutils.cfg" has been written to:
      #{distutils}
    specifying the install-scripts folder as:
      #{scripts_folder}

    If you install Python packages via "pypy3 setup.py install", easy_install_pypy3,
    or pip_pypy3, any provided scripts will go into the install-scripts folder
    above, so you may want to add it to your PATH *after* #{HOMEBREW_PREFIX}/bin
    so you don't overwrite tools from CPython.

    Setuptools and pip have been installed, so you can use easy_install_pypy3 and
    pip_pypy3.
    To update pip and setuptools between pypy3 releases, run:
        pip_pypy3 install --upgrade pip setuptools

    See: https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Homebrew-and-Python.md
    EOS
  end

  # The HOMEBREW_PREFIX location of site-packages
  def prefix_site_packages
    HOMEBREW_PREFIX+"lib/pypy3/site-packages"
  end

  # Where setuptools will install executable scripts
  def scripts_folder
    HOMEBREW_PREFIX+"share/pypy3"
  end

  # The Cellar location of distutils
  def distutils
    libexec+"lib-python/3/distutils"
  end

  test do
    system bin/"pypy3", "-c", "print('Hello, world!')"
    system scripts_folder/"pip", "list"
  end
end
