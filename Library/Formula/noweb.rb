class Noweb < Formula
  desc "WEB-like literate-programming tool"
  homepage "https://www.cs.tufts.edu/~nr/noweb/"
  url "ftp://www.eecs.harvard.edu/pub/nr/noweb.tgz"
  version "2.11b"
  sha256 "c913f26c1edb37e331c747619835b4cade000b54e459bb08f4d38899ab690d82"

  bottle do
    cellar :any
    sha256 "34dd66401fe717e1ed384114d7037ea7a6e0aaabe6f2a98f314c8d6bb41c25be" => :yosemite
    sha256 "54bf1e45409d1c022d08dee3a43c4e2d7f038a646f00a5d5f2f6db90ff54d668" => :mavericks
    sha256 "d422058f08a621f2d6ab78adabb887b550754cbb3c8581c31fe72f52300fc3f5" => :mountain_lion
  end

  depends_on "icon"

  def texpath
    prefix/"tex/generic/noweb"
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
