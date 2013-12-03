require 'formula'

class Pdns < Formula
  homepage 'http://wiki.powerdns.com'
  url 'https://autotest.powerdns.com/job/auth-git/4582/artifact/pdns-3.3.1-snapshot-20131203-4582-d1e2482.tar.gz'
  sha256 '9f908b3d979c90c3bb5bbe49045fa673172b6128f1d201d68e82b3e722024e82'

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
