require 'formula'

class Pdksh < Formula
  url 'http://www.cs.mun.ca/~michael/pdksh/files/pdksh-5.2.14.tar.gz'
  homepage 'http://www.cs.mun.ca/~michael/pdksh/'
  md5 '871106b3bd937e1afba9f2ef7c43aef3'

  # sort command that works with leopard+
  def patches
    { :p0 => "https://trac.macports.org/export/90549/trunk/dports/shells/pdksh/files/patch-siglist.sh.diff"
    }
  end

  def install
    inreplace "Makefile.in" do |s|
      s.gsub! "$(prefix)/man/man$(manext)", "$(prefix)/share/man/man1"
    end

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
