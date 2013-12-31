require 'formula'

# Necessary until upstream resolves the incompatibility issue with texinfo 5.
# When this is fixed upstream, replace with a normal texinfo dependency
class Texinfo4 < Formula
  homepage 'http://www.gnu.org/software/texinfo/'
  url 'http://ftp.gnu.org/gnu/texinfo/texinfo-4.13a.tar.gz'
  sha1 'a1533cf8e03ea4fa6c443b73f4c85e4da04dead0'
end

class Lilypond < Formula
  homepage 'http://lilypond.org/'
  url 'http://download.linuxaudio.org/lilypond/sources/v2.18/lilypond-2.18.0.tar.gz'
  sha1 '8bf2637b27351b999c535a219fe20407d359910a'

  head 'git://git.sv.gnu.org/lilypond.git'

  devel do
    url 'http://download.linuxaudio.org/lilypond/source/v2.17/lilypond-2.17.95.tar.gz'
    sha1 'fb4dedb14a5616b2ac1f9031030c9a615f807548'
  end

  option 'with-doc', "Build documentation in addition to binaries (may require several hours)."

  depends_on :tex
  depends_on :x11
  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'pango'
  depends_on 'guile18'
  depends_on 'ghostscript'
  depends_on 'mftrace'
  depends_on 'fontforge' => ["with-x", "with-cairo"]
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
    depends_on :python => ['dbtexmf.dblatex' => 'dblatex']
    depends_on 'texi2html'
  end

  def install
    # This texinfo4 business will be no longer needed, either,
    # once the aforementioned issue is resolved.
    texinfo4_prefix = libexec+'texinfo4'
    Texinfo4.new.brew do
      system "./configure", "--disable-dependency-tracking",
                            "--disable-install-warnings",
                            "--prefix=#{texinfo4_prefix}"
      system "make CXX=#{ENV.cxx} install"
    end
    ENV.prepend_path 'PATH', "#{texinfo4_prefix}/bin"

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
    system "#{bin}/lilypond", "test.ly"
  end
end
