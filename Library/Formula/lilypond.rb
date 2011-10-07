require 'formula'

class Lilypond < Formula
  url 'http://download.linuxaudio.org/lilypond/sources/v2.14/lilypond-2.14.2.tar.gz'
  homepage 'http://lilypond.org/'
  md5 '4053a19e03181021893981280feb9aaa'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'pango'
  depends_on 'guile'
  depends_on 'ghostscript'
  depends_on 'mftrace'
  depends_on 'fontforge'
  depends_on 'texinfo'

  skip_clean :all

  def install
    abort caveats unless quiet_system "/usr/bin/which -s mpost"

    gs = Formula.factory('ghostscript')
    system "./configure", "--prefix=#{prefix}",
                          "--with-ncsb-dir=#{gs.share}/ghostscript/fonts/"

    # Separate steps to ensure that lilypond's custom fonts are created.
    system "make"
    system "make install"
  end

  def caveats; <<-EOS.undent
    Lilypond requires a version of TeX, such as TeX Live or MacTeX, prior to installing.
    Available at: http://www.tug.org/mactex/
    EOS
  end
end
