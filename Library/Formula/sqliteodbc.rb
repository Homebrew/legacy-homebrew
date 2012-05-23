require 'formula'

class Sqliteodbc < Formula
  homepage 'http://www.ch-werner.de/sqliteodbc/'
  url      'http://www.ch-werner.de/sqliteodbc/sqliteodbc-0.95.tar.gz'
  md5      '44a43b914656feea347b1d5981bc3791'

  depends_on 'sqlite'

  def options
    [
      ['--universal', 'Build for both 32 & 64 bit Intel.']
    ]
  end

  def install
    args = ["--prefix=#{prefix}"]
    if ARGV.build_universal?
      ENV['CFLAGS'] = '-arch i386 -arch x86_64'
      ENV['LDFLAGS'] = '-arch i386 -arch x86_64'
      args << '--disable-dependency-tracking'
    end
    args << "--with-sqlite3=#{HOMEBREW_PREFIX}"

    system './configure', *args
    system 'make install'

    dylib_src      = prefix + 'libsqlite3odbc-0.95.dylib'
    static_lib_src = prefix + 'libsqlite3odbc.a'

    lib.install dylib_src => 'libsqlite3odbc.dylib'
    lib.install static_lib_src
  end

  def test
    File.exists? File.join(lib, 'libsqlite3odbc.dylib')
    File.exists? File.join(lib, 'libsqlite3odbc.a')
  end
end
