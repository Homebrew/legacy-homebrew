require 'formula'

class Gregorio < Formula
  url 'http://download.gna.org/gregorio/releases/current/gregorio-2.0.tar.gz'
  homepage 'http://home.gna.org/gregorio/'
  md5 '53994e8ea7f3fe4148a66262b6c7d144'
  head 'svn://svn.gna.org/svn/gregorio/trunk'
  depends_on 'fontforge'

  if ARGV.build_head?
    depends_on 'gettext'
  end

  def install
    if ARGV.build_head?
      system "brew link gettext"
      system "autoreconf", "-f", "-i"
      system "brew unlink gettext"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end

  def caveats; <<-EOS.undent
    Gregorio requires a TeX Live installation to run.
    Instead of installing a TeX system through Homebrew,
    we recommend using a MacTeX distribution: http://www.tug.org/mactex/
    EOS
  end
end
