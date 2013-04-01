require 'formula'

class Mariadb < Formula
  homepage 'http://mariadb.org/'
  url 'http://ftp.osuosl.org/pub/mariadb/mariadb-5.5.30/kvm-tarbake-jaunty-x86/mariadb-5.5.30.tar.gz'
  sha1 'aa0cb78b8d709d765e4a58953ecdceefc48af5a7'

  depends_on 'cmake' => :build
  depends_on 'pidof' unless MacOS.version >= :mountain_lion

  option :universal
  option 'with-tests', 'Keep test when installing'
  option 'with-bench', 'Keep benchmark app when installing'
  option 'client-only', 'Install only client tools'
  option 'with-embedded', 'Build the embedded server'
  option 'with-libedit', 'Compile with editline wrapper instead of readline'
  option 'with-archive-storage-engine', 'Compile with the ARCHIVE storage engine enabled'
  option 'with-blackhole-storage-engine', 'Compile with the BLACKHOLE storage engine enabled'
  option 'enable-local-infile', 'Build with local infile loading support'

  conflicts_with 'mysql',
    :because => "mariadb and mysql install the same binaries."

  conflicts_with 'percona-server',
    :because => "mariadb and percona-server install the same binaries."

  conflicts_with 'mysql-cluster',
    :because => "mariadb and mysql-cluster install the same binaries."

  env :std if build.universal?

  fails_with :clang do
    build 421
  end

  def patches
    # fix build on Xcode only systems
    DATA
  end

  def install
    # Build without compiler or CPU specific optimization flags to facilitate
    # compilation of gems and other software that queries `mysql-config`.
    ENV.minimal_optimization

    # Make sure the var/mysql directory exists
    (var+"mysql").mkpath

    cmake_args = %W[
      .
      -DCMAKE_INSTALL_PREFIX=#{prefix}
      -DMYSQL_DATADIR=#{var}/mysql
      -DINSTALL_MANDIR=#{man}
      -DINSTALL_DOCDIR=#{doc}
      -DINSTALL_MYSQLSHAREDIR=#{share.basename}/mysql
      -DWITH_SSL=yes
      -DDEFAULT_CHARSET=utf8
      -DDEFAULT_COLLATION=utf8_general_ci
      -DINSTALL_SYSCONFDIR=#{etc}
    ]

    # Client only
    cmake_args << "-DWITHOUT_SERVER=1" if build.include? 'client-only'

    # Build the embedded server
    cmake_args << "-DWITH_EMBEDDED_SERVER=ON" if build.include? 'with-embedded'

    # Compile with readline unless libedit is explicitly chosen
    cmake_args << "-DWITH_READLINE=yes" unless build.include? 'with-libedit'

    # Compile with ARCHIVE engine enabled if chosen
    cmake_args << "-DWITH_ARCHIVE_STORAGE_ENGINE=1" if build.include? 'with-archive-storage-engine'

    # Compile with BLACKHOLE engine enabled if chosen
    cmake_args << "-DWITH_BLACKHOLE_STORAGE_ENGINE=1" if build.include? 'with-blackhole-storage-engine'

    # Make universal for binding to universal applications
    cmake_args << "-DCMAKE_OSX_ARCHITECTURES='i386;x86_64'" if build.universal?

    # Build with local infile loading support
    cmake_args << "-DENABLED_LOCAL_INFILE=1" if build.include? 'enable-local-infile'

    system "cmake", *cmake_args
    system "make"
    system "make install"

    # Don't create databases inside of the prefix!
    # See: https://github.com/mxcl/homebrew/issues/4975
    rm_rf prefix+'data'

    (prefix+'mysql-test').rmtree unless build.include? 'with-tests' # save 121MB!
    (prefix+'sql-bench').rmtree unless build.include? 'with-bench'

    # Link the setup script into bin
    ln_s prefix+'scripts/mysql_install_db', bin+'mysql_install_db'

    # Fix up the control script and link into bin
    inreplace "#{prefix}/support-files/mysql.server" do |s|
      s.gsub!(/^(PATH=".*)(")/, "\\1:#{HOMEBREW_PREFIX}/bin\\2")
      # pidof can be replaced with pgrep from proctools on Mountain Lion
      s.gsub!(/pidof/, 'pgrep') if MacOS.version >= :mountain_lion
    end

    # Fix my.cnf to point to #{etc} instead of /etc
    inreplace "#{etc}/my.cnf" do |s|
      s.gsub!("!includedir /etc/my.cnf.d", "!includedir #{etc}/my.cnf.d")
    end

    ln_s "#{prefix}/support-files/mysql.server", bin
  end

  def caveats; <<-EOS.undent
    Set up databases with:
        unset TMPDIR
        mysql_install_db --user=\`whoami\` --basedir="$(brew --prefix mariadb)" --datadir=#{var}/mysql --tmpdir=/tmp
    EOS
  end

  plist_options :manual => "mysql.server start"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>KeepAlive</key>
      <true/>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>Program</key>
      <string>#{HOMEBREW_PREFIX}/bin/mysqld_safe</string>
      <key>RunAtLoad</key>
      <true/>
      <key>UserName</key>
      <string>#{`whoami`.chomp}</string>
      <key>WorkingDirectory</key>
      <string>#{var}</string>
    </dict>
    </plist>
    EOS
  end
end

__END__
diff --git a/cmake/libutils.cmake b/cmake/libutils.cmake
index 7c13df0..c82de4d 100644
--- a/cmake/libutils.cmake
+++ b/cmake/libutils.cmake
@@ -183,7 +183,7 @@ MACRO(MERGE_STATIC_LIBS TARGET OUTPUT_NAME LIBS_TO_MERGE)
       # binaries properly)
       ADD_CUSTOM_COMMAND(TARGET ${TARGET} POST_BUILD
         COMMAND rm ${TARGET_LOCATION}
-        COMMAND /usr/bin/libtool -static -o ${TARGET_LOCATION} 
+        COMMAND libtool -static -o ${TARGET_LOCATION} 
         ${STATIC_LIBS}
       )  
     ELSE()
