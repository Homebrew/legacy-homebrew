class MysqlCluster < Formula
  desc "Shared-nothing clustering and auto-sharding for MySQL"
  homepage "https://www.mysql.com/products/cluster/"
  url "https://dev.mysql.com/get/Downloads/MySQL-Cluster-7.4/mysql-cluster-gpl-7.4.9.tar.gz"
  sha256 "c577817a9c378f0e968b7d851c03e37a0101a4713c9f1ad762ac739f17d359bc"

  bottle do
    sha256 "102ee4654331a073ee7d53142e74d2be148d12898825b3f5064a405ff59ba88c" => :el_capitan
    sha256 "ea873f00bef200c76c4a214f5a07c75bc60023c27b900e9fa554478711194f0a" => :yosemite
    sha256 "d44cd4807b7dcdb32c58bab30e258310baa2f2fc1f510254f1fdccc150f75bb9" => :mavericks
  end

  option :universal
  option "with-test", "Build with unit tests"
  option "with-embedded", "Build the embedded server"
  option "with-libedit", "Compile with editline wrapper instead of readline"
  option "with-archive-storage-engine", "Compile with the ARCHIVE storage engine enabled"
  option "with-blackhole-storage-engine", "Compile with the BLACKHOLE storage engine enabled"
  option "with-local-infile", "Build with local infile loading support"
  option "with-debug", "Build with debug support"

  deprecated_option "with-tests" => "with-test"
  deprecated_option "enable-local-infile" => "with-local-infile"
  deprecated_option "enable-debug" => "with-debug"

  depends_on :java => "1.7+"
  depends_on "cmake" => :build
  depends_on "pidof" unless MacOS.version >= :mountain_lion
  depends_on "openssl"

  conflicts_with "memcached", :because => "both install `bin/memcached`"
  conflicts_with "mysql", "mariadb", "percona-server",
    :because => "mysql, mariadb, and percona install the same binaries."

  fails_with :clang do
    build 500
    cause "http://article.gmane.org/gmane.comp.db.mysql.cluster/2085"
  end

  def install
    # Build without compiler or CPU specific optimization flags to facilitate
    # compilation of gems and other software that queries `mysql-config`.
    ENV.minimal_optimization

    # Make sure the var/mysql-cluster directory exists
    (var/"mysql-cluster").mkpath

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
    if build.with? "test"
      args << "-DENABLE_DOWNLOADS=ON"
    else
      args << "-DWITH_UNIT_TESTS=OFF"
    end

    # Build the embedded server
    args << "-DWITH_EMBEDDED_SERVER=ON" if build.with? "embedded"

    # Compile with readline unless libedit is explicitly chosen
    args << "-DWITH_READLINE=yes" if build.without? "libedit"

    # Compile with ARCHIVE engine enabled if chosen
    args << "-DWITH_ARCHIVE_STORAGE_ENGINE=1" if build.with? "archive-storage-engine"

    # Compile with BLACKHOLE engine enabled if chosen
    args << "-DWITH_BLACKHOLE_STORAGE_ENGINE=1" if build.with? "blackhole-storage-engine"

    # Make universal for binding to universal applications
    if build.universal?
      ENV.universal_binary
      args << "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.universal_archs.as_cmake_arch_flags}"
    end

    # Build with local infile loading support
    args << "-DENABLED_LOCAL_INFILE=1" if build.with? "local-infile"

    # Build with debug support
    args << "-DWITH_DEBUG=1" if build.with? "debug"

    system "cmake", *args
    system "make"
    system "make", "install"

    # Create default directories and configuration files
    (var/"mysql-cluster/ndb_data").mkpath
    (var/"mysql-cluster/mysqld_data").mkpath
    (var/"mysql-cluster/conf").mkpath
    (var/"mysql-cluster/conf/my.cnf").write my_cnf unless File.exist? var/"mysql-cluster/conf/my.cnf"
    (var/"mysql-cluster/conf/config.ini").write config_ini unless File.exist? var/"mysql-cluster/conf/config.ini"

    plist_path("ndb_mgmd").write ndb_mgmd_startup_plist("ndb_mgmd")
    plist_path("ndb_mgmd").chmod 0644
    plist_path("ndbd").write ndbd_startup_plist("ndbd")
    plist_path("ndbd").chmod 0644
    plist_path("mysqld").write mysqld_startup_plist("mysqld")
    plist_path("mysqld").chmod 0644

    # Don't create databases inside of the prefix!
    # See: https://github.com/Homebrew/homebrew/issues/4975
    rm_rf prefix+"data"

    # Link the setup script into bin
    bin.install_symlink prefix/"scripts/mysql_install_db"
    # Fix up the control script and link into bin
    inreplace "#{prefix}/support-files/mysql.server" do |s|
      s.gsub!(/^(PATH=".*)(")/, "\\1:#{HOMEBREW_PREFIX}/bin\\2")
      # pidof can be replaced with pgrep from proctools on Mountain Lion
      s.gsub!(/pidof/, "pgrep") if MacOS.version >= :mountain_lion
    end
    bin.install_symlink prefix/"support-files/mysql.server"

    # Move mysqlaccess to libexec
    libexec.mkpath
    libexec.install "#{bin}/mysqlaccess", "#{bin}/mysqlaccess.conf",
                    "#{bin}/mcc_config.py"
  end

  def caveats; <<-EOS.undent
    To get started with MySQL Cluster, read MySQL Cluster Quick Start at
      https://dev.mysql.com/downloads/cluster/

    Default configuration files have been created inside:
      #{var}/mysql-cluster
    Note that in a production system there are other parameters
    that you would set to tune the configuration.

    Set up databases to run AS YOUR USER ACCOUNT with:
      unset TMPDIR
      mysql_install_db --verbose --user=`whoami` --basedir="#{opt_prefix}" --datadir=#{var}/mysql-cluster/mysqld_data --tmpdir=/tmp

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
    extra ? super()+"-"+extra : super()+"-ndb_mgmd"
  end

  # Override Formula#plist_path
  def plist_path(extra = nil)
    extra ? super().dirname+(plist_name(extra)+".plist") : super()
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
      <key>WorkingDirectory</key>
      <string>#{var}</string>
      <key>StandardOutPath</key>
      <string>#{var}/mysql-cluster/#{name}.log</string>
    </dict>
    </plist>
    EOS
  end

  test do
    system "/bin/sh", "-n", "#{bin}/mysqld_safe"
    (prefix/"mysql-test").cd do
      system "./mysql-test-run.pl", "status", "--vardir=#{testpath}"
    end
  end
end
