require 'formula'

class Pango < Formula
  homepage 'http://www.pango.org/'
  url 'http://ftp.gnome.org/pub/gnome/sources/pango/1.29/pango-1.29.3.tar.bz2'
  sha256 'a177f455f358a9b075e3b5d7e04891d90380c551e3ec28125e3d9aacca7dd43b'

  depends_on 'pkg-config' => :build
  depends_on 'glib'

  fails_with_llvm "Undefined symbols when linking", :build => "2326"

  if MacOS.leopard?
    depends_on 'fontconfig' # Leopard's fontconfig is too old.
    depends_on 'cairo' # Leopard doesn't come with Cairo.
  elsif MacOS.lion?
    depends_on 'cairo' # links against system Cairo without this
  end

  def install
    arg = ["--disable-dependency-tracking",
           "--disable-debug",
           "--prefix=#{prefix}",
           "--enable-man",
           "--with-x",
           "--with-html-dir=#{share}/doc" ]
    system "./configure", *arg
    system "make"
    system "make install"
  end

  def test
    aprog = "#{HOMEBREW_PREFIX}/bin/pango-view"
    bprog = "/usr/bin/qlmanage"
    if File.exists? aprog and File.exists? bprog
      mktemp do
        puts
        system "#{aprog} -t 'diggity ☜ ☃ ♻' --waterfall --rotate=10 --annotate=1 --header -q -o output.png"
        system "#{bprog} -p output.png"
        oh1 "Success.  That was crafted using the cairo backend."
        puts
      end
    else
      opoo <<-EOS.undent
        The test was not run because it was not able to locate one
        or more of the following files:
            #{aprog}
            #{bprog}
      EOS
      puts
    end
  end
end