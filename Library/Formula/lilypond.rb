require 'formula'

class Lilypond <Formula
  url 'http://download.linuxaudio.org/lilypond/sources/v2.13/lilypond-2.13.23.tar.gz'
  homepage 'http://lilypond.org/'
  md5 '741190abdd2217cf9f4ea6abff66accf'

  depends_on 'pkg-config'
  # The guile version must be < 1.9
  depends_on 'guile'
  depends_on 'gettext'
  depends_on 'ghostscript'
  depends_on 'pango'
  depends_on 'mftrace'
  depends_on 'fontforge'
  depends_on 'texinfo'

  skip_clean :all

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-ncsb-dir=#{Formula.factory('ghostscript').share}/ghostscript/fonts/"

    # Separate steps to ensure that lilypond's custom fonts are created.
    system "make"
    system "make install"
  end

  def caveats
    "Lilypond requires a version of TeX, such as TeX Live or MacTeX, prior to installing."
  end
end
