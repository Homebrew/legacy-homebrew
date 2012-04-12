require 'formula'

class TigerVnc < Formula
  homepage 'http://tigervnc.org/'
  url 'http://downloads.sourceforge.net/project/tigervnc/tigervnc/1.0.1/tigervnc-1.0.1.tar.gz'
  md5 'daca3eb16afe65253b766eccb8bfdbc5'

  def install
    cd "unix" do
      system "./configure", "--disable-debug", "--disable-dependency-tracking",
                            "--prefix=#{prefix}"
      system "make install"
    end
  end

  def caveats
    "NOTE: This is X11 software."
  end
end
