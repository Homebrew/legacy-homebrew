require 'formula'

class Mariadb < Formula
  homepage 'http://mariadb.org/'
  url 'http://ftp.osuosl.org/pub/mariadb/mariadb-5.5.27/kvm-tarbake-jaunty-x86/mariadb-5.5.27.tar.gz'
  sha1 '0f10c6294f44f4a595e2f96317a2b5e04a13ba4f'

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
      -DINSTALL_MYSQLSHAREDIR=#{share.basename}/#{name}
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
    ln_s "#{prefix}/support-files/mysql.server", bin
  end

  def caveats; <<-EOS.undent
    Set up databases with:
        unset TMPDIR
        mysql_install_db

    If this is your first install, automatically load on login with:
        cp #{plist_path} ~/Library/LaunchAgents/
        launchctl load -w ~/Library/LaunchAgents/#{plist_path.basename}

    If this is an upgrade and you already have the #{plist_path.basename} loaded:
        launchctl unload -w ~/Library/LaunchAgents/#{plist_path.basename}
        cp #{plist_path} ~/Library/LaunchAgents/
        launchctl load -w ~/Library/LaunchAgents/#{plist_path.basename}

    Note on upgrading:
        We overwrite any existing #{plist_path.basename} in ~/Library/LaunchAgents
        if we are upgrading because previous versions of this brew created the
        plist with a version specific program argument.

    Or start manually with:
        mysql.server start
    EOS
  end

  def startup_plist; <<-EOPLIST.undent
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
    EOPLIST
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
