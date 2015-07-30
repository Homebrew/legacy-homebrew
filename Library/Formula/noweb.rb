require 'formula'

class Noweb < Formula
  desc "WEB-like literate-programming tool"
  homepage 'http://www.cs.tufts.edu/~nr/noweb/'
  url 'ftp://www.eecs.harvard.edu/pub/nr/noweb.tgz'
  version '2.11b'
  sha256 'c913f26c1edb37e331c747619835b4cade000b54e459bb08f4d38899ab690d82'

  depends_on 'icon'

  def texpath
    prefix/'tex/generic/noweb'
  end

  def install
    cd "src" do
      system "bash", "awkname", "awk"
      system "make LIBSRC=icon ICONC=icont CFLAGS='-U_POSIX_C_SOURCE -D_POSIX_C_SOURCE=1'"

      bin.mkpath
      lib.mkpath
      man.mkpath
      texpath.mkpath

      system "make", "install", "BIN=#{bin}",
                                "LIB=#{lib}",
                                "MAN=#{man}",
                                "TEXINPUTS=#{texpath}"
      cd "icon" do
        system "make", "install", "BIN=#{bin}",
                                  "LIB=#{lib}",
                                  "MAN=#{man}",
                                  "TEXINPUTS=#{texpath}"
      end
    end
  end

  def caveats; <<-EOS.undent
    TeX support files are installed in the directory:

      #{texpath}

    You may need to add the directory to TEXINPUTS to run noweb properly.
    EOS
  end
end
