require 'formula'

class Lilypond < Formula
  homepage 'http://lilypond.org/'
  url 'http://download.linuxaudio.org/lilypond/sources/v2.16/lilypond-2.16.2.tar.gz'
  sha1 '1eb3b0e5c117a8669dba19ab28f933351e51e39a'

  devel do
    url  'http://download.linuxaudio.org/lilypond/source/v2.17/lilypond-2.17.13.tar.gz'
    sha1 '7e82aa8388b754abb4c34aa2ae2b6fa4d32e6658'
  end

  env :std

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
  depends_on 'fondu'
  # Add dependency on keg-only Homebrew 'flex' because Apple bundles an older and incompatible
  # version of the library with 10.7 at least, seems slow keeping up with updates,
  # and the extra brew is tiny anyway.
  depends_on 'flex' => :build

  # Assert documentation dependencies if requested.
  if build.include? 'with-doc'
    depends_on 'netpbm'
    depends_on 'imagemagick'
    depends_on 'docbook'
    depends_on LanguageModuleDependency.new(:python, 'dblatex', 'dbtexmf.dblatex')
    depends_on 'texi2html'
  end

  fails_with :clang do
    cause 'Strict C99 compliance error in a pointer conversion.'
  end

  def install
    gs = Formula.factory('ghostscript')

    args = ["--prefix=#{prefix}",
            "--enable-rpath",
            "--with-ncsb-dir=#{gs.share}/ghostscript/fonts/"]

    args << "--disable-documentation" unless build.include? 'with-doc'
    system "./configure", *args

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
      \\header { title = "Do-Re-Mi" }
      { c' d' e' }
    EOS
    lilykeg = Formula.factory('lilypond').linked_keg
    system "#{lilykeg}/bin/lilypond test.ly"
  end
end
