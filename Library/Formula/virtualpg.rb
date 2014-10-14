require 'formula'

class Virtualpg < Formula
  homepage 'https://www.gaia-gis.it/fossil/virtualpg/index'
  url 'http://www.gaia-gis.it/gaia-sins/virtualpg-1.0.1.tar.gz'
  sha1 '20849c368a2bef3e8532765589d0b6b445d56908'

  depends_on 'libspatialite'
  depends_on 'postgis'

  def install

    # New SQLite3 extension won't load via SELECT load_extension('mod_virtualpg');
    # unless named mod_virtualpg.dylib (should actually be mod_virtualpg.bundle)
    # See: https://groups.google.com/forum/#!topic/spatialite-users/EqJAB8FYRdI
    # needs upstream fixes in both SQLite and libtool
    inreplace "configure",
    "shrext_cmds='`test .$module = .yes && echo .so || echo .dylib`'",
    "shrext_cmds='.dylib'"

    system "./configure", "--enable-shared=yes",
                          "--disable-dependency-tracking",
                          "--with-pgconfig=#{Formula["postgresql"].opt_bin}/pg_config",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # Verify mod_virtualpg extension can be loaded using Homebrew's SQLite
    system "echo \"SELECT load_extension('#{opt_lib}/mod_virtualpg');\" | #{Formula["sqlite"].opt_bin}/sqlite3"
  end
end
