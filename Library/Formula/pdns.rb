require 'formula'

class Pdns < Formula
  homepage 'http://wiki.powerdns.com'
  url 'http://downloads.powerdns.com/releases/pdns-3.2.tar.gz'
  sha256 'd1895aba065446dc68e5d7cc792d5303626c71759f61a455531ed65d59c06572'

  option 'pgsql', 'Enable the PostgreSQL backend'

  depends_on 'pkg-config' => :build
  depends_on 'boost'
  depends_on 'lua'
  depends_on 'sqlite'
  depends_on :postgresql if build.include? 'pgsql'

  def install
    args = ["--prefix=#{prefix}",
            "--with-lua",
            "--with-sqlite3",
            "--with-sqlite=#{Formula.factory("sqlite").opt_prefix}"]

    # Include the PostgreSQL backend if requested
    if build.include? "pgsql"
      args << "--with-modules=gsqlite3 gpgsql"
    else
      # SQLite3 backend only is the default
      args << "--with-modules=gsqlite3"
    end

    system "./configure", *args

    # Compilation fails at polarssl if we skip straight to make install
    system "make"
    system "make install"

  end
end
