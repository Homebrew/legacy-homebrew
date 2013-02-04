require 'formula'

class Lilypond < Formula
  homepage 'http://lilypond.org/'
  url 'http://download.linuxaudio.org/lilypond/sources/v2.16/lilypond-2.16.1.tar.gz'
  sha1 'ce923f27091ec5501df7bcd0596f1ffd7ab9b8b9'

  option 'with-doc', "Build documentation in addition to binaries (may require several hours)."

  depends_on :tex
  depends_on :x11
  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'pango'
  depends_on 'guile'
  depends_on 'ghostscript'
  depends_on 'mftrace'
  depends_on 'fontforge' => ["with-x", "with-cairo"]
  depends_on 'texinfo'

  # Assert documentation dependencies if requested.
  if build.include? 'with-doc'
    depends_on 'netpbm'
    depends_on 'imagemagick'
    depends_on 'docbook'
    depends_on LanguageModuleDependency.new(:python, 'dblatex', 'dbtexmf.dblatex')
    depends_on 'texi2html'
  end

  fails_with :clang do
    build 425
    cause 'Strict C99 compliance error in a pointer conversion.'
  end

  def install
    gs = Formula.factory('ghostscript')
    system "./configure", "--prefix=#{prefix}",
                          "--enable-rpath",
                          "--with-ncsb-dir=#{gs.share}/ghostscript/fonts/"

    # Separate steps to ensure that lilypond's custom fonts are created.
    system 'make all'
    system "make install"

    # Build documentation if requested.
    if build.include? 'with-doc'
      system "make doc"
      system "make install-doc"
    end
  end

  test do
    (testpath/'test.ly').write <<-EOS.undent
      \\version "2.16.0"
      \\header { title = "Do-Re-Mi" }
      { c' d' e' }
    EOS
    lilykeg = Formula.factory('lilypond').linked_keg
    system "#{lilykeg}/bin/lilypond test.ly"
  end
end
