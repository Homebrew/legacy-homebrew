require 'formula'

class SqliteFunctions < Formula
  url 'http://www.sqlite.org/contrib/download/extension-functions.c?get=25', :using  => :nounzip
  md5 '3a32bfeace0d718505af571861724a43'
  version '2010-01-06'
end

class SqliteDocs < Formula
  url 'http://www.sqlite.org/sqlite-doc-3071100.zip'
  sha1 '87cbed1918c2604daefd3588a8555067e55e53cf'
  version '3.7.11'
end

class Sqlite < Formula
  homepage 'http://sqlite.org/'
  url 'http://www.sqlite.org/sqlite-autoconf-3071100.tar.gz'
  sha1 'a768f76b10df84d6a2c66178544d42725a8fdaf0'
  version '3.7.11'

  depends_on 'readline' => :optional

  def options
  [
    ["--with-docs", "Install HTML documentation"],
    ["--without-rtree", "Disable the R*Tree index module"],
    ["--with-fts", "Enable the FTS Module"],
    ["--universal", "Build a universal binary"],
    ["--with-functions", "Enable more math and string functions for SQL queries"]
  ]
  end

  def install
    # O2 and O3 leads to corrupt/invalid rtree indexes
    # http://groups.google.com/group/spatialite-users/browse_thread/thread/8e1cfa79f2d02a00#
    ENV.Os

    ENV.append 'CPPFLAGS', "-DSQLITE_ENABLE_RTREE" unless ARGV.include? "--without-rtree"
    ENV.append 'CPPFLAGS', "-DSQLITE_ENABLE_FTS3 -DSQLITE_ENABLE_FTS3_PARENTHESIS" if ARGV.include? "--with-fts"

    # enable these options by default
    ENV.append 'CPPFLAGS', "-DSQLITE_ENABLE_COLUMN_METADATA"
    ENV.append 'CPPFLAGS', "-DSQLITE_ENABLE_STAT3"

    ENV.universal_binary if ARGV.build_universal?

    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking", "--enable-dynamic-extensions"
    system "make install"

    if ARGV.include? "--with-functions"
      SqliteFunctions.new.brew { mv 'extension-functions.c?get=25', buildpath/'extension-functions.c' }
      system ENV.cc, "-fno-common", "-dynamiclib", "extension-functions.c", "-o", "libsqlitefunctions.dylib", *ENV.cflags.split
      lib.install "libsqlitefunctions.dylib"
    end

    SqliteDocs.new.brew { doc.install Dir['*'] } if ARGV.include? "--with-docs"
  end

  def caveats
    if ARGV.include? '--with-functions' then <<-EOS.undent
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
