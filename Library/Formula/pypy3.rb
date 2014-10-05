require "formula"

class Pypy3 < Formula
  homepage "http://pypy.org/"
  url "https://bitbucket.org/pypy/pypy/downloads/pypy3-2.3.1-src.tar.bz2"
  sha1 "b9a0d9759f6f383e5c9edab4a21c3b8768f28dbd"
  bottle do
    cellar :any
    sha1 "51f93930d175a44e6f97aa7827f46f1e009f0c1a" => :mavericks
    sha1 "298a86ebee02ba6669887c9ae4bb880d2ddbbf6d" => :mountain_lion
    sha1 "edf9c97210ef71120a8691d6c04a81ac18f3f234" => :lion
  end

  revision 1

  depends_on :arch => :x86_64
  depends_on "pkg-config" => :build
  depends_on "openssl"

  resource "setuptools" do
    url "https://pypi.python.org/packages/source/s/setuptools/setuptools-6.0.2.tar.gz"
    sha1 "a29a81b7913151697cb15b069844af75d441408f"
  end

  resource "pip" do
    url "https://pypi.python.org/packages/source/p/pip/pip-1.5.6.tar.gz"
    sha1 "e6cd9e6f2fd8d28c9976313632ef8aa8ac31249e"
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
             "-Ojit", "--shared", "--cc", ENV["CC"], "--translation-verbose",
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

    # Symlinks to easy_install_pypy3 and pip_pypy3
    bin.install_symlink scripts_folder/"easy_install" => "easy_install_pypy3"
    bin.install_symlink scripts_folder/"pip" => "pip_pypy3"

    # post_install happens after linking
    %w[easy_install_pypy3 pip_pypy3].each{ |e| (HOMEBREW_PREFIX/"bin").install_symlink bin/e }
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
    To update setuptools and pip between pypy3 releases, run:
        #{scripts_folder}/pip install --upgrade setuptools pip

    See: https://github.com/Homebrew/homebrew/wiki/Homebrew-and-Python
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
end
