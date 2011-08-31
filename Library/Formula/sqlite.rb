require 'formula'

class SqliteFunctions < Formula
  url 'http://www.sqlite.org/contrib/download/extension-functions.c?get=25', :using  => NoUnzipCurlDownloadStrategy
  md5 '3a32bfeace0d718505af571861724a43'
  version '2010-01-06'
end

class Sqlite < Formula
  homepage 'http://sqlite.org/'
  url 'http://www.sqlite.org/sqlite-autoconf-3070701.tar.gz'
  md5 '554026fe7fac47b1cf61c18d5fe43419'
  version '3.7.7.1'

  def options
  [
    ["--with-rtree", "Enables the R*Tree index module"],
    ["--with-fts", "Enables the FTS Module"],
    ["--universal", "Build a universal binary."],
    ["--with-functions", "Enables more math and string functions for SQL queries."]
  ]
  end

  def install
    if ARGV.include? "--with-functions"
    	d=Pathname.getwd
        SqliteFunctions.new.brew { d.install Dir["*"] }
    	mv 'extension-functions.c?get=25', 'extension-functions.c'
        system "gcc", "-fno-common", "-dynamiclib", "extension-functions.c", "-o", "libsqlitefunctions.dylib"
        lib.install "libsqlitefunctions.dylib"
    end
    
    ENV.append "CFLAGS", "-DSQLITE_ENABLE_RTREE=1" if ARGV.include? "--with-rtree"
    ENV.append "CPPFLAGS","-DSQLITE_ENABLE_FTS3 -DSQLITE_ENABLE_FTS3_PARENTHESIS" if ARGV.include? "--with-fts"
    ENV.universal_binary if ARGV.build_universal?
    system "./configure", "--prefix=#{prefix}",
                          (ARGV.include? "--with-functions") ? "--enable-dynamic-extensions" : "",
                          "--disable-dependency-tracking"
    system "make install"
  end
  
  def caveats
    if ARGV.include? "--with-functions"
      <<-EOS.undent
      Usage instructions for applications calling the sqlite3 API functions:

        In your application, call sqlite3_enable_load_extension(db,1) to
        allow loading external libraries.  Then load the library libsqlitefunctions
        using sqlite3_load_extension; the third argument should be 0.
        See http://www.sqlite.org/cvstrac/wiki?p=LoadableExtensions.
        Select statements may now use these functions, as in
        SELECT cos(radians(inclination)) FROM satsum WHERE satnum = 25544;
      
      Usage instructions for the sqlite3 program:

        If the program is built so that loading extensions is permitted,
        the following will work:
         sqlite> SELECT load_extension('#{lib}/libsqlitefunctions.dylib');
         sqlite> select cos(radians(45));
         0.707106781186548
      EOS
    end  
  end
end
