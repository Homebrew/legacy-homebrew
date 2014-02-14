require 'formula'

class PythonEnvironment < Requirement
  fatal true

  def error_message
    if !Formula.factory("python").installed? && ARGV.include?("--with-python3")
      error_message =  <<-EOS.undent
        You cannot use system Python 2 and Homebrew's Python 3
        simultaneously.
        Either `brew install python` or use `--without-python3`.
      EOS
    elsif ARGV.include?("--without-python") && !ARGV.include?("--with-python3")
      error_message =  " --with-python3 must be specified when using --without-python"
    end
  end

  satisfy do
    error_message == nil
  end

  def message
    error_message
  end
end

class Pygobject3 < Formula
  homepage 'http://live.gnome.org/PyGObject'
  url 'http://ftp.gnome.org/pub/GNOME/sources/pygobject/3.10/pygobject-3.10.2.tar.xz'
  sha256 '75608f2c4052f0277508fc79debef026d9e84cb9261de2b922387c093d32c326'

  option 'with-tests', 'run tests'

  depends_on 'pkg-config' => :build

  if build.with? 'tests'
    depends_on 'automake' => :build
    depends_on 'autoconf' => :build
    depends_on 'libtool' => :build
    depends_on 'gnome-common' => :build
    depends_on 'gtk+3' => :build
  end

  depends_on 'libffi' => :optional
  depends_on 'glib'
  depends_on :python => :recommended
  depends_on :python3 => :optional
  depends_on 'py2cairo' if build.with? 'python'
  depends_on 'py3cairo' if build.with? 'python3'
  depends_on 'gobject-introspection'

  option :universal

  depends_on PythonEnvironment

  def pythons
    pythons = []
    ["python", "python3"].each do |python|
      next if build.without? python
      version = /\d\.\d/.match `#{python} --version 2>&1`
      pythons << [python, version]
    end
    pythons
  end

  def patches
    "https://gist.github.com/krrk/6439665/raw/a527e14cd3a77c19b089f27bea884ce46c988f55/pygobject-fix-module.patch" if build.with? 'tests'
  end

  def install
    ENV.universal_binary if build.universal?

    if build.with? 'tests'
      # autogen.sh is necessary to update the build system after the above
      # patch and XDG_DATA_DIRS needs to be fixed for some tests to run
      inreplace 'tests/Makefile.am', '/usr/share', HOMEBREW_PREFIX/'share'
      system "./autogen.sh"
    end

    pythons.each do |python, version|
      ENV["PYTHON"] = "#{python}"
      system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
      system "make", "install"
      system "make", "check" if build.with? 'tests'
      system "make", "clean" if pythons.length > 1
    end
  end

  test do
    Pathname('test.py').write <<-EOS.undent
      from gi.repository import Gtk
      win = Gtk.Window()
      win.connect("delete-event", Gtk.main_quit)
      win.show_all()
    EOS
    pythons.each do |python, version|
      unless Formula.factory(python).installed?
        ENV["PYTHONPATH"] = HOMEBREW_PREFIX/"lib/python#{version}/site-packages"
        ENV.append_path "PYTHONPATH", "#{opt_prefix}/lib/python#{version}/site-packages"
      end
      system python, "test.py"
    end
  end
end
