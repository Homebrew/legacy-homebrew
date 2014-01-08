require 'formula'

class Noweb < Formula
  homepage 'http://www.cs.tufts.edu/~nr/noweb/'
  url 'ftp://www.eecs.harvard.edu/pub/nr/noweb.tgz'
  version '2.11b'
  sha1 '3b391c42f46dcb8a002b863fb2e483560a7da51d'

  depends_on 'icon'

  def install
    cd "src" do
      system "bash", "awkname", "awk"
      system "make LIBSRC=icon ICONC=icont CFLAGS='-U_POSIX_C_SOURCE -D_POSIX_C_SOURCE=1'"

      if which 'kpsewhich'
        ohai 'TeX installation found. Installing TeX support files there might fail if your user does not have permission'
        texmf = Pathname.new(`kpsewhich -var-value=TEXMFLOCAL`.chomp)
      else
        ohai 'No TeX installation found. Installing TeX support files in the noweb Cellar.'
        texmf = prefix
      end

      bin.mkpath
      lib.mkpath
      man.mkpath
      (texmf/'tex/generic/noweb').mkpath

      system "make", "install", "BIN=#{bin}",
                                "LIB=#{lib}",
                                "MAN=#{man}",
                                "TEXINPUTS=#{texmf}/tex/generic/noweb"
    end
  end
end
