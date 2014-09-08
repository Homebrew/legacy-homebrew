require 'formula'

class Pdns < Formula
  homepage 'http://www.powerdns.com'
  head 'https://github.com/powerdns/pdns.git'
  url 'http://downloads.powerdns.com/releases/pdns-3.3.1.tar.gz'
  sha1 '555862bf9635d1dcab2c4f3b7569bdd8212ef67f'

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
            "--with-sqlite=#{Formula["sqlite"].opt_prefix}"]

    # Include the PostgreSQL backend if requested
    if build.include? "pgsql"
      args << "--with-modules=gsqlite3 gpgsql"
    else
      # SQLite3 backend only is the default
      args << "--with-modules=gsqlite3"
    end

    system "./bootstrap" if build.head?
    system "./configure", *args

    # Compilation fails at polarssl if we skip straight to make install
    system "make"
    system "make install"

  end
end
