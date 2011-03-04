require 'formula'

<<-COMMENTS
Versions
--------
This formula is currently tracking version 2.7.x.

Python 3.x is available as a separate formula:
  brew install python3

Options
-------
There are a few options for customzing the build.
  --universal: Builds combined 32-/64-bit Intel binaries.
  --framework: Builds a "Framework" version of Python.
  --static:    Builds static instead of shared libraries.

site-packages
-------------
The "site-packages" folder lives in the Cellar, under the "lib" folder
for normal builds, and under the "Frameworks" folder for Framework builds.

A .pth file is added to the Cellar site-packages that adds the corresponding
HOMEBREW_PREFIX folder (/usr/local/lib/python2.7/site-packages by default)
to sys.path. Note that this alternate folder doesn't itself support .pth files.

pip / distribute
----------------
The pip (and distribute) formulae in Homebrew are designed only to work
against a Homebrew-installed Python, though they provide links for
manually installing against a custom Python.

pip and distribute are installed directly into the Cellar site-packages,
since they need to install to a place that supports .pth files.

The pip & distribute formuale use the "site_packages" method defined here
to get the appropriate site-packages path.

COMMENTS


# Was a Framework build requested?
def build_framework?; ARGV.include? '--framework'; end

# Are we installed or installing as a Framework?
def as_framework?
  (self.installed? and File.exists? prefix+"Frameworks/Python.framework") or build_framework?
end

class Python <Formula
  url 'http://www.python.org/ftp/python/2.7.1/Python-2.7.1.tar.bz2'
  homepage 'http://www.python.org/'
  md5 'aa27bc25725137ba155910bd8e5ddc4f'

  depends_on 'readline' => :optional  # Prefer over OS X's libedit
  depends_on 'sqlite'   => :optional  # Prefer over OS X's older version
  depends_on 'gdbm'     => :optional

  def options
    [
      ["--framework", "Do a 'Framework' build instead of a UNIX-style build."],
      ["--universal", "Build for both 32 & 64 bit Intel."],
      ["--static", "Build static libraries."]
    ]
  end

  # Skip binaries so modules will load; skip lib because it is mostly Python files
  skip_clean ['bin', 'lib']

  def site_packages
    # The Cellar location of site-packages
    if as_framework?
      # If we're installed or installing as a Framework, then use that location.
      return prefix+"Frameworks/Python.framework/Versions/2.7/lib/python2.7/site-packages"
    else
      # Otherwise use just 'lib'
      return lib+"python2.7/site-packages"
    end
  end

  def exec_prefix
    if as_framework?
      # If we're installed or installing as a Framework, then use that location.
      return prefix+"Frameworks/Python.framework/Versions/2.7/bin"
    else
      # Otherwise just use 'bin'
      return bin
    end
  end

  def prefix_site_packages
    # The HOMEBREW_PREFIX location of site-packages
    HOMEBREW_PREFIX+"lib/python2.7/site-packages"
  end

  def validate_options
    if build_framework? and ARGV.include? "--static"
      onoe "Cannot specify both framework and static."
      exit 99
    end
  end

  def install
    validate_options

    args = ["--prefix=#{prefix}"]

    if ARGV.include? '--universal'
      args << "--enable-universalsdk=/" << "--with-universal-archs=intel"
    end

    if build_framework?
      args << "--enable-framework=#{prefix}/Frameworks"
    else
      args << "--enable-shared" unless ARGV.include? '--static'
    end

    # allow sqlite3 module to load extensions
    inreplace "setup.py",
      'sqlite_defines.append(("SQLITE_OMIT_LOAD_EXTENSION", "1"))',
      '#sqlite_defines.append(("SQLITE_OMIT_LOAD_EXTENSION", "1"))'

    system "./configure", *args
    system "make"
    ENV.j1 # Installs must be serialized
    system "make install"

    # Add the Homebrew prefix path to site-packages via a .pth
    prefix_site_packages.mkpath
    (site_packages+"homebrew.pth").write prefix_site_packages
  end

  def caveats
    framework_caveats = <<-EOS.undent
      Framework Python was installed to:
        #{prefix}/Frameworks/Python.framework

      You may want to symlink this Framework to a standard OS X location,
      such as:
        mkdir ~/Frameworks
        ln -s "#{prefix}/Frameworks/Python.framework" ~/Frameworks

    EOS

    site_caveats = <<-EOS.undent
      The site-packages folder for this Python is:
        #{site_packages}

      We've added a "homebrew.pth" file to also include:
        #{prefix_site_packages}

    EOS

    general_caveats = <<-EOS.undent
      You may want to create a "virtual environment" using this Python as a base
      so you can manage multiple independent site-packages. See:
        http://pypi.python.org/pypi/virtualenv

      If you install Python packages via pip, binaries will be installed under
      Python's cellar but not automatically linked into the Homebrew prefix.
      You may want to add Python's bin folder to your PATH as well:
        #{exec_prefix}
    EOS

    s = site_caveats+general_caveats
    s = framework_caveats + s if as_framework?
    return s
  end
end