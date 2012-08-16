require 'formula'

class Fontforge < Formula
  homepage 'http://fontforge.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/fontforge/fontforge-source/fontforge_full-20120731-b.tar.bz2'
  sha1 'b520f532b48e557c177dffa29120225066cc4e84'
  version '20120731'

  head 'https://github.com/fontforge/fontforge.git'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'pango'
  depends_on 'potrace'
  depends_on 'libspiro'
  depends_on :x11

  def options
    [['--without-python', 'Build without Python.']]
  end

  fails_with :llvm do
    build 2336
    cause "Compiling cvexportdlg.c fails with error: initializer element is not constant"
  end

  def install
    args = ["--prefix=#{prefix}",
            "--enable-double",
            "--without-freetype-bytecode"]

    if ARGV.include? "--without-python"
      args << "--without-python"
    else
      python_prefix = `python-config --prefix`.strip
      python_version = `python-config --libs`.match('-lpython(\d+\.\d+)').captures.at(0)
      args << "--with-python-headers=#{python_prefix}/include/python#{python_version}"
      args << "--with-python-lib=-lpython#{python_version}"
      args << "--enable-pyextension"
    end

    # Fix linking to correct Python library
    ENV.prepend "LDFLAGS", "-L#{python_prefix}/lib" unless ARGV.include? "--without-python"
    # Fix linker error; see: http://trac.macports.org/ticket/25012
    ENV.append "LDFLAGS", "-lintl"
    # Reset ARCHFLAGS to match how we build
    ENV["ARCHFLAGS"] = MacOS.prefer_64_bit? ? "-arch x86_64" : "-arch i386"

    system "./configure", *args

    # Fix hard-coded install locations that don't respect the target bindir
    inreplace "Makefile" do |s|
      s.gsub! "/Applications", "$(prefix)"
      s.gsub! "ln -s /usr/local/bin/fontforge", "ln -s $(bindir)/fontforge"
    end

    # Fix install location of Python extension; see:
    # http://sourceforge.net/mailarchive/message.php?msg_id=26827938
    inreplace "Makefile" do |s|
      s.gsub! "python setup.py install --prefix=$(prefix) --root=$(DESTDIR)", "python setup.py install --prefix=$(prefix)"
    end

    # Fix hard-coded include file paths. Reported usptream:
    # http://sourceforge.net/mailarchive/forum.php?thread_name=C1A32103-A62D-468B-AD8A-A8E0E7126AA5%40smparkes.net&forum_name=fontforge-devel
    # https://trac.macports.org/ticket/33284
    inreplace %w(fontforge/macbinary.c fontforge/startui.c gutils/giomime.c) do |s|
      s.gsub! "/Developer", MacOS::Xcode.prefix
    end

    system "make"
    system "make install"
  end

  def which_python
    "python" + `python -c 'import sys;print(sys.version[:3])'`.strip
  end

  def caveats
    general_caveats = <<-EOS.undent
      fontforge is an X11 application.

      To install the Mac OS X wrapper application run:
        brew linkapps
      or:
        ln -s #{prefix}/FontForge.app /Applications
    EOS

    python_caveats = <<-EOS.undent

      To use the Python extension with non-homebrew Python, you need to amend your
      PYTHONPATH like so:
        export PYTHONPATH=#{HOMEBREW_PREFIX}/lib/#{which_python}/site-packages:$PYTHONPATH
    EOS

    s = general_caveats
    s += python_caveats unless ARGV.include? "--without-python"
    return s
  end
end
