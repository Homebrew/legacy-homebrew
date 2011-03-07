require 'formula'

class Fontforge <Formula
  url 'http://downloads.sourceforge.net/project/fontforge/fontforge-source/fontforge_full-20110222.tar.bz2'
  homepage 'http://fontforge.sourceforge.net'
  md5 '5be4dda345b5d73a27cc399df96e463a'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'pango'
  depends_on 'potrace'

  def install
    ENV.x11
    fails_with_llvm "Compiling cvexportdlg.c fails with error: initializer element is not constant"
    system "./configure", "--prefix=#{prefix}",
                          "--enable-double",
                          "--without-freetype-bytecode",
                          "--without-python"

    inreplace "Makefile" do |s|
      s.gsub! "/Applications", "$(prefix)"
      s.gsub! "/usr/local/bin", "$(bindir)"
    end

    system "make"
    system "make install"
  end

  def caveats; <<-EOS.undent
    fontforge is an X11 application.

    To install the Mac OS X wrapper application run:
      $ brew linkapps
    or:
      $ sudo ln -s #{prefix}/FontForge.app /Applications
    EOS
  end
end
