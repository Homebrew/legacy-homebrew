require 'formula'

class Fontforge < Formula
  homepage 'http://fontforge.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/fontforge/fontforge-source/fontforge_full-20110222.tar.bz2'
  md5 '5be4dda345b5d73a27cc399df96e463a'

  head 'git://fontforge.git.sourceforge.net/gitroot/fontforge/fontforge'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'pango'
  depends_on 'potrace'
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

    args << "--without-python" if ARGV.include? "--without-python"

    # Fix linker error; see: http://trac.macports.org/ticket/25012
    ENV.append "LDFLAGS", "-lintl"
    system "./configure", *args

    # Fix hard-coded install locations that don't respect the target bindir
    inreplace "Makefile" do |s|
      s.gsub! "/Applications", "$(prefix)"
      s.gsub! "ln -s /usr/local/bin/fontforge", "ln -s $(bindir)/fontforge"
    end

    # Fix hard-coded include file paths. Reported usptream:
    # http://sourceforge.net/mailarchive/forum.php?thread_name=C1A32103-A62D-468B-AD8A-A8E0E7126AA5%40smparkes.net&forum_name=fontforge-devel
    # https://trac.macports.org/ticket/33284
    header_prefix = MacOS::Xcode.prefix
    inreplace %w(fontforge/macbinary.c fontforge/startui.c gutils/giomime.c) do |s|
      s.gsub! "/Developer", header_prefix
    end

    system "make"
    system "make install"
  end

  def caveats; <<-EOS.undent
    fontforge is an X11 application.

    To install the Mac OS X wrapper application run:
        brew linkapps
    or:
        ln -s #{prefix}/FontForge.app /Applications
    EOS
  end
end
