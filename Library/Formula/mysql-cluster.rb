require 'formula'

class MysqlNotInstalled < Requirement
  def message; <<-EOS.undent
    You need to disable the mysql formula with

      launchctl unload -w ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist
      brew unlink mysql

    before installing MySQL Cluster.
    EOS
  end
  def satisfied?
    not File.exists?(HOMEBREW_PREFIX+'bin/mysqld')
  end
  def fatal?
    true
  end
end

class MysqlCluster < Formula
  homepage 'http://www.mysql.com/cluster/'
  url 'http://mysql.llarian.net/Downloads/MySQL-Cluster-7.2/mysql-cluster-gpl-7.2.6.tar.gz'
  sha1 'f5523f877391b95a2428f37047028df6361251f0'

  depends_on MysqlNotInstalled.new
  depends_on 'cmake' => :build
  depends_on 'readline'
  depends_on 'pidof'

  fails_with :clang do
    build 318
    cause "http://article.gmane.org/gmane.comp.db.mysql.cluster/2085"
  end

  skip_clean :all # So "INSTALL PLUGIN" can work.

  def options
    [
      ['--with-tests', "Build with unit tests."],
      ['--with-embedded', "Build the embedded server."],
      ['--with-libedit', "Compile with EditLine wrapper instead of readline"],
      ['--with-archive-storage-engine', "Compile with the ARCHIVE storage engine enabled"],
      ['--with-blackhole-storage-engine', "Compile with the BLACKHOLE storage engine enabled"],
      ['--universal', "Make mysql a universal binary"],
      ['--enable-local-infile', "Build with local infile loading support"]
    ]
  end

  # Remove optimization flags from `mysql_config --cflags`
  # This facilitates easy compilation of gems using a brewed mysql
  # CMake patch needed for CMake 2.8.8.
  # Reported here: http://bugs.mysql.com/bug.php?id=65050
  # See also the mysql formula.
  def patches; DATA; end

  def install
    # Make sure the var/mysql-cluster directory exists
    (var+"mysql-cluster").mkpath

    args = [".",
            "-DCMAKE_INSTALL_PREFIX=#{prefix}",
            "-DMYSQL_DATADIR=#{var}/mysql-cluster",
            "-DINSTALL_MANDIR=#{man}",
            "-DINSTALL_DOCDIR=#{doc}",
            "-DINSTALL_INFODIR=#{info}",
            # CMake prepends prefix, so use share.basename
            "-DINSTALL_MYSQLSHAREDIR=#{share.basename}/mysql",
            "-DWITH_SSL=yes",
            "-DDEFAULT_CHARSET=utf8",
            "-DDEFAULT_COLLATION=utf8_general_ci",
            "-DSYSCONFDIR=#{etc}"]

    # To enable unit testing at build, we need to download the unit testing suite
    if ARGV.include? '--with-tests'
      args << "-DENABLE_DOWNLOADS=ON"
    else
      args << "-DWITH_UNIT_TESTS=OFF"
    end

    # Build the embedded server
    args << "-DWITH_EMBEDDED_SERVER=ON" if ARGV.include? '--with-embedded'

    # Compile with readline unless libedit is explicitly chosen
    args << "-DWITH_READLINE=yes" unless ARGV.include? '--with-libedit'

    # Compile with ARCHIVE engine enabled if chosen
    args << "-DWITH_ARCHIVE_STORAGE_ENGINE=1" if ARGV.include? '--with-archive-storage-engine'

    # Compile with BLACKHOLE engine enabled if chosen
    args << "-DWITH_BLACKHOLE_STORAGE_ENGINE=1" if ARGV.include? '--with-blackhole-storage-engine'

    # Make universal for binding to universal applications
    args << "-DCMAKE_OSX_ARCHITECTURES='i386;x86_64'" if ARGV.build_universal?

    # Build with local infile loading support
    args << "-DENABLED_LOCAL_INFILE=1" if ARGV.include? '--enable-local-infile'

    system "cmake", *args
    system "make"
    system "make install"

    # Create default directories and configuration files
    (var+"mysql-cluster/ndb_data").mkpath
    (var+"mysql-cluster/mysqld_data").mkpath
    (var+"mysql-cluster/conf").mkpath
    (var+"mysql-cluster/conf/my.cnf").write my_cnf unless File.exists? var+"mysql-cluster/conf/my.cnf"
    (var+"mysql-cluster/conf/config.ini").write config_ini unless File.exists? var+"mysql-cluster/conf/config.ini"

    plist_path('ndb_mgmd').write ndb_mgmd_startup_plist('ndb_mgmd')
    plist_path('ndb_mgmd').chmod 0644
    plist_path('ndbd').write ndbd_startup_plist('ndbd')
    plist_path('ndbd').chmod 0644
    plist_path('mysqld').write mysqld_startup_plist('mysqld')
    plist_path('mysqld').chmod 0644

    # Don't create databases inside of the prefix!
    # See: https://github.com/mxcl/homebrew/issues/4975
    rm_rf prefix+'data'

    # Link the setup script into bin
    ln_s prefix+'scripts/mysql_install_db', bin+'mysql_install_db'
    # Fix up the control script and link into bin
    inreplace "#{prefix}/support-files/mysql.server" do |s|
      s.gsub!(/^(PATH=".*)(")/, "\\1:#{HOMEBREW_PREFIX}/bin\\2")
    end
    ln_s "#{prefix}/support-files/mysql.server", bin
  end

  def caveats; <<-EOS.undent
    To get started with MySQL Cluster, read MySQL Cluster Quick Start at
      http://dev.mysql.com/downloads/cluster/

    Default configuration files have been created inside:
      #{var}/mysql-cluster
    Note that in a production system there are other parameters
    that you would set to tune the configuration.

    Launchd plists templates to automatically load the various nodes can be copied from:
      #{plist_path('ndb_mgmd')}
      #{plist_path('ndbd')}
      #{plist_path('mysqld')}

    For a first cluster, you may start with a single MySQL Server (mysqld),
    a pair of Data Nodes (ndbd) and a single management node (ndb_mgmd):

      mysql_install_db --no-defaults --basedir=#{prefix} --datadir=#{var}/mysql-cluster/mysqld_data
      ndb_mgmd -f #{var}/mysql-cluster/conf/config.ini --initial --configdir=#{var}/mysql-cluster/conf/
      ndbd -c localhost:1186
      ndbd -c localhost:1186
      mkdir -p ~/Library/LaunchAgents
      cp #{plist_path('mysqld')} ~/Library/LaunchAgents/
      launchctl load -w ~/Library/LaunchAgents/#{plist_path('mysqld').basename}
      mysql -h 127.0.0.1 -P 5000 -u root -p
      (Leave the password empty and press Enter)
        create database clusterdb;
        use clusterdb;
        create table simples (id int not null primary key) engine=ndb;
        insert into simples values (1),(2),(3),(4);
        select * from simples;

    To shutdown everything:

      launchctl unload -w ~/Library/LaunchAgents/#{plist_path('mysqld').basename}
      ndb_mgm -e shutdown
    EOS
  end

  def my_cnf; <<-EOCNF.undent
    [mysqld]
    ndbcluster
    datadir=#{var}/mysql-cluster/mysqld_data
    basedir=#{prefix}
    port=5000
    EOCNF
  end

  def config_ini; <<-EOCNF.undent
    [ndb_mgmd]
    hostname=localhost
    datadir=#{var}/mysql-cluster/ndb_data
    NodeId=1

    [ndbd default]
    noofreplicas=2
    datadir=#{var}/mysql-cluster/ndb_data

    [ndbd]
    hostname=localhost
    NodeId=3

    [ndbd]
    hostname=localhost
    NodeId=4

    [mysqld]
    NodeId=50
    EOCNF
  end

  # Override Formula#plist_name
  def plist_name(extra = nil)
    (extra) ? super()+'-'+extra : super()
  end

  # Override Formula#plist_path
  def plist_path(extra = nil)
    (extra) ? super().dirname+(plist_name(extra)+'.plist') : super()
  end

  def mysqld_startup_plist(name); <<-EOPLIST.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>KeepAlive</key>
      <true/>
      <key>Label</key>
      <string>#{plist_name(name)}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{HOMEBREW_PREFIX}/bin/mysqld</string>
        <string>--defaults-file=#{var}/mysql-cluster/conf/my.cnf</string>
      </array>
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

  def ndb_mgmd_startup_plist(name); <<-EOPLIST.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>KeepAlive</key>
      <true/>
      <key>Label</key>
      <string>#{plist_name(name)}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{HOMEBREW_PREFIX}/bin/ndb_mgmd</string>
        <string>--nodaemon</string>
        <string>-f</string>
        <string>#{var}/mysql-cluster/conf/config.ini</string>
        <string>--initial</string>
        <string>--configdir=#{var}/mysql-cluster/conf/</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>UserName</key>
      <string>#{`whoami`.chomp}</string>
      <key>WorkingDirectory</key>
      <string>#{var}</string>
      <key>StandardOutPath</key>
      <string>#{var}/mysql-cluster/#{name}.log</string>
    </dict>
    </plist>
    EOPLIST
  end

  def ndbd_startup_plist(name); <<-EOPLIST.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>KeepAlive</key>
      <true/>
      <key>Label</key>
      <string>#{plist_name(name)}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{HOMEBREW_PREFIX}/bin/ndbd</string>
        <string>--nodaemon</string>
        <string>-c</string>
        <string>localhost:1186</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>UserName</key>
      <string>#{`whoami`.chomp}</string>
      <key>WorkingDirectory</key>
      <string>#{var}</string>
      <key>StandardOutPath</key>
      <string>#{var}/mysql-cluster/#{name}.log</string>
    </dict>
    </plist>
    EOPLIST
  end
end


__END__
diff --git a/configure.cmake b/configure.cmake
index 6d90b78..3d6118c 100644
--- a/configure.cmake
+++ b/configure.cmake
@@ -151,7 +151,9 @@ IF(UNIX)
   SET(CMAKE_REQUIRED_LIBRARIES 
     ${LIBM} ${LIBNSL} ${LIBBIND} ${LIBCRYPT} ${LIBSOCKET} ${LIBDL} ${CMAKE_THREAD_LIBS_INIT} ${LIBRT})
 
-  LIST(REMOVE_DUPLICATES CMAKE_REQUIRED_LIBRARIES)
+  IF(CMAKE_REQUIRED_LIBRARIES)
+    LIST(REMOVE_DUPLICATES CMAKE_REQUIRED_LIBRARIES)
+  ENDIF()
   LINK_LIBRARIES(${CMAKE_THREAD_LIBS_INIT})
   
   OPTION(WITH_LIBWRAP "Compile with tcp wrappers support" OFF)
diff --git a/scripts/mysql_config.sh b/scripts/mysql_config.sh
index b62386a..2e8bf44 100644
--- a/scripts/mysql_config.sh
+++ b/scripts/mysql_config.sh
@@ -137,7 +137,9 @@ for remove in DDBUG_OFF DSAFE_MUTEX DUNIV_MUST_NOT_INLINE DFORCE_INIT_OF_VARS \
               DEXTRA_DEBUG DHAVE_purify O 'O[0-9]' 'xO[0-9]' 'W[-A-Za-z]*' \
               'mtune=[-A-Za-z0-9]*' 'mcpu=[-A-Za-z0-9]*' 'march=[-A-Za-z0-9]*' \
               Xa xstrconst "xc99=none" AC99 \
-              unroll2 ip mp restrict
+              unroll2 ip mp restrict \
+              mmmx 'msse[0-9.]*' 'mfpmath=sse' w pipe 'fomit-frame-pointer' 'mmacosx-version-min=10.[0-9]' \
+              aes Os
 do
   # The first option we might strip will always have a space before it because
   # we set -I$pkgincludedir as the first option
