require 'formula'

class Lilypond < Formula
  homepage 'http://lilypond.org/'
  url 'http://download.linuxaudio.org/lilypond/sources/v2.18/lilypond-2.18.2.tar.gz'
  sha1 '09d3a1e0e9fadeb8ef6e279227a2b30812c7ee9b'

  devel do
    url 'http://download.linuxaudio.org/lilypond/source/v2.19/lilypond-2.19.10.tar.gz'
    sha1 '3c54889945e08b4df4afff9a98c3ec2e8fc5836f'
  end

  # LilyPond currently only builds with an older version of Guile (<1.9)
  resource 'guile18' do
    url 'http://ftpmirror.gnu.org/guile/guile-1.8.8.tar.gz'
    sha1 '548d6927aeda332b117f8fc5e4e82c39a05704f9'
  end

  env :std

  option 'with-doc', "Build documentation in addition to binaries (may require several hours)."

  # Dependencies for LilyPond
  depends_on :tex
  depends_on :x11
  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'pango'
  depends_on 'ghostscript'
  depends_on 'mftrace'
  depends_on 'fontforge' => ["with-x", "with-cairo"]
  depends_on 'fondu'
  depends_on 'texinfo'

  # Additional dependencies for guile1.8.
  depends_on :libtool
  depends_on 'libffi'
  depends_on 'libunistring'
  depends_on 'bdw-gc'
  depends_on 'gmp'
  depends_on 'readline'

  # Add dependency on keg-only Homebrew 'flex' because Apple bundles an older and incompatible
  # version of the library with 10.7 at least, seems slow keeping up with updates,
  # and the extra brew is tiny anyway.
  depends_on 'flex' => :build

  # Assert documentation dependencies if requested.
  if build.with? "doc"
    depends_on 'netpbm'
    depends_on 'imagemagick'
    depends_on 'docbook'
    depends_on "dblatex" => [:python, "dbtexmf.dblatex"]
    depends_on :python if MacOS.version <= :snow_leopard
    depends_on 'texi2html'
  end

  fails_with :clang do
    cause 'Strict C99 compliance error in a pointer conversion.'
  end

  def install
    # The contents of the following block are taken from the guile18 formula
    # in homebrew/versions.
    resource('guile18').stage do
       system "./configure", "--disable-dependency-tracking",
                             "--prefix=#{prefix}",
                             "--with-libreadline-prefix=#{Formula["readline"].opt_prefix}"
       system "make", "install"
       # A really messed up workaround required on OS X --mkhl
       lib.cd { Dir["*.dylib"].each {|p| ln_sf p, File.basename(p, ".dylib")+".so" }}
       ENV.prepend_path 'PATH', "#{bin}"
    end

    gs = Formula["ghostscript"]

    args = ["--prefix=#{prefix}",
            "--enable-rpath",
            "--with-ncsb-dir=#{gs.share}/ghostscript/fonts/"]

    args << "--disable-documentation" if build.without? "doc"
    system "./configure", *args

    # Separate steps to ensure that lilypond's custom fonts are created.
    system 'make all'
    system "make install"

    # Build documentation if requested.
    if build.with? "doc"
      system "make doc"
      system "make install-doc"
    end
  end

  def caveats; <<-EOS.undent
    Lilypond requires a newer version of mpost. Assuming a standard install of
    MacTeX, you will need to use `tlmgr` update its installed packages:

      sudo tlmgr update --self && sudo tlmgr update --all
    EOS
  end

  test do
    (testpath/'test.ly').write <<-EOS.undent
      \\header { title = "Do-Re-Mi" }
      { c' d' e' }
    EOS
    system "#{bin}/lilypond", "test.ly"
  end
end
