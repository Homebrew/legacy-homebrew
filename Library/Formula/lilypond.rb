require 'formula'

class TexInstalled < Requirement
  def message; <<-EOS.undent
    A TeX/LaTeX installation is required to install.
    You can obtain the TeX distribution for Mac OS X from:
        http://www.tug.org/mactex/
    EOS
  end
  def satisfied?
    which 'mpost'
  end
  def fatal?
    true
  end
end

class Lilypond < Formula
  homepage 'http://lilypond.org/'
  url 'http://download.linuxaudio.org/lilypond/sources/v2.14/lilypond-2.14.2.tar.gz'
  md5 '4053a19e03181021893981280feb9aaa'

  depends_on TexInstalled.new
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
    gs = Formula.factory('ghostscript')
    system "./configure", "--prefix=#{prefix}",
                          "--with-ncsb-dir=#{gs.share}/ghostscript/fonts/"

    # Separate steps to ensure that lilypond's custom fonts are created.
    system "make"
    system "make install"
  end
end
