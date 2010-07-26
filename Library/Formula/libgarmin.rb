require 'formula'

class Libgarmin <Formula
  head 'http://libgarmin.svn.sourceforge.net/svnroot/libgarmin/libgarmin/dev/'
  homepage 'http://libgarmin.sourceforge.net/'

  def install
    system "./autosh.sh" unless File.exist? "configure"
    system "./configure", "--prefix=#{prefix}"

    # Fix OS X include
    inreplace Dir["{src,utils}/*.c"], "#include <malloc.h>", "#include <stdlib.h>"

    # The code for creating 'verison.h' doesn't work on OS X.
    inreplace "Makefile" do |s|
      s.change_make_var! "BUILT_SOURCES", ""
    end

    File.open("version.h","w") do |f|
      f.puts "#define LIBVERSION \"libgarmin 0.1\""
    end

    system "make"

    # Yep, need to recreate before make and make install
    File.open("version.h","w") do |f|
      f.puts "#define LIBVERSION \"libgarmin 0.1\""
    end

    system "make install"
  end
end
