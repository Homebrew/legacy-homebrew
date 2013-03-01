require 'formula'

class MysqlCluster < Formula
  homepage 'http://www.mysql.com/cluster/'
  url 'http://mysql.llarian.net/Downloads/MySQL-Cluster-7.2/mysql-cluster-gpl-7.2.8.tar.gz'
  sha1 '5bcb69d35eea9b4a45dd6025f2af13d6b1fc4d19'

  depends_on 'cmake' => :build
  depends_on 'pidof' unless MacOS.version >= :mountain_lion

  option :universal
  option 'with-tests', 'Build with unit tests'
  option 'with-embedded', 'Build the embedded server'
  option 'with-libedit', 'Compile with editline wrapper instead of readline'
  option 'with-archive-storage-engine', 'Compile with the ARCHIVE storage engine enabled'
  option 'with-blackhole-storage-engine', 'Compile with the BLACKHOLE storage engine enabled'
  option 'enable-local-infile', 'Build with local infile loading support'
  option 'enable-debug', 'Build with debug support'

  conflicts_with 'mysql',
    :because => "mysql-cluster and mysql install the same binaries."

  conflicts_with 'mariadb',
    :because => "mysql-cluster and mariadb install the same binaries."

  conflicts_with 'percona-server',
    :because => "mysql-cluster and percona-server install the same binaries."

  env :std if build.universal?

  fails_with :clang do
    build 421
    cause "http://article.gmane.org/gmane.comp.db.mysql.cluster/2085"
  end

  def install
    # Build without compiler or CPU specific optimization flags to facilitate
    # compilation of gems and other software that queries `mysql-config`.
    ENV.minimal_optimization

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
    if build.include? 'with-tests'
      args << "-DENABLE_DOWNLOADS=ON"
    else
      args << "-DWITH_UNIT_TESTS=OFF"
    end

    # Build the embedded server
    args << "-DWITH_EMBEDDED_SERVER=ON" if build.include? 'with-embedded'

    # Compile with readline unless libedit is explicitly chosen
    args << "-DWITH_READLINE=yes" unless build.include? 'with-libedit'

    # Compile with ARCHIVE engine enabled if chosen
    args << "-DWITH_ARCHIVE_STORAGE_ENGINE=1" if build.include? 'with-archive-storage-engine'

    # Compile with BLACKHOLE engine enabled if chosen
    args << "-DWITH_BLACKHOLE_STORAGE_ENGINE=1" if build.include? 'with-blackhole-storage-engine'

    # Make universal for binding to universal applications
    args << "-DCMAKE_OSX_ARCHITECTURES='i386;x86_64'" if build.universal?

    # Build with local infile loading support
    args << "-DENABLED_LOCAL_INFILE=1" if build.include? 'enable-local-infile'

    # Build with debug support
    args << "-DWITH_DEBUG=1" if build.include? 'enable-debug'

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
      # pidof can be replaced with pgrep from proctools on Mountain Lion
      s.gsub!(/pidof/, 'pgrep') if MacOS.version >= :mountain_lion
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

    Set up databases to run AS YOUR USER ACCOUNT with:
      unset TMPDIR
      mysql_install_db --verbose --user=`whoami` --basedir="$(brew --prefix mysql-cluster)" --datadir=#{var}/mysql-cluster/mysqld_data --tmpdir=/tmp

    For a first cluster, you may start with a single MySQL Server (mysqld),
    a pair of Data Nodes (ndbd) and a single management node (ndb_mgmd):

      ndb_mgmd -f #{var}/mysql-cluster/conf/config.ini --initial --configdir=#{var}/mysql-cluster/conf/
      ndbd -c localhost:1186
      ndbd -c localhost:1186
      mysqld --defaults-file=/usr/local/var/mysql-cluster/conf/my.cnf &
      mysql -h 127.0.0.1 -P 5000 -u root -p
      (Leave the password empty and press Enter)
        create database clusterdb;
        use clusterdb;
        create table simples (id int not null primary key) engine=ndb;
        insert into simples values (1),(2),(3),(4);
        select * from simples;

    To shutdown everything:

      mysqladmin -u root -p shutdown
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
    (extra) ? super()+'-'+extra : super()+'-ndb_mgmd'
  end

  # Override Formula#plist_path
  def plist_path(extra = nil)
    (extra) ? super().dirname+(plist_name(extra)+'.plist') : super()
  end

  def mysqld_startup_plist(name); <<-EOS.undent
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
    EOS
  end

  def ndb_mgmd_startup_plist(name); <<-EOS.undent
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
    EOS
  end

  def ndbd_startup_plist(name); <<-EOS.undent
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
    EOS
  end
end
