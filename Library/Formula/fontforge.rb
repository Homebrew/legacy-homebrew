require 'formula'

class Fontforge < Formula
  url 'http://downloads.sourceforge.net/project/fontforge/fontforge-source/fontforge_full-20110222.tar.bz2'
  head 'git://fontforge.git.sourceforge.net/gitroot/fontforge/fontforge'
  homepage 'http://fontforge.sourceforge.net'
  md5 '5be4dda345b5d73a27cc399df96e463a'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'pango'
  depends_on 'potrace'

  def options
    [['--without-python', 'Build without Python.']]
  end

  fails_with_llvm "Compiling cvexportdlg.c fails with error: initializer element is not constant", :build => 2336

  def install
    args = ["--prefix=#{prefix}", "--enable-double", "--without-freetype-bytecode"]
    args << "--without-python" if ARGV.include? "--without-python"

    ENV.x11
    # Fix linker error; see: http://trac.macports.org/ticket/25012
    ENV.append "LDFLAGS", "-lintl"
    system "./configure", *args

    # Fix hard-coded install locations that don't respect the target bindir
    inreplace "Makefile" do |s|
      s.gsub! "/Applications", "$(prefix)"
      s.gsub! "ln -s /usr/local/bin/fontforge", "ln -s $(bindir)/fontforge"
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
