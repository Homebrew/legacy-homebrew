class PerconaServer < Formula
  desc "Drop-in MySQL replacement"
  homepage "https://www.percona.com"
  url "https://www.percona.com/downloads/Percona-Server-5.6/Percona-Server-5.6.28-76.1/source/tarball/percona-server-5.6.28-76.1.tar.gz"
  version "5.6.28-76.1"
  sha256 "ab8ab794a58a82132645ae84b74de91c7f9a5bcf81f2162628ce8976a00a4fd4"

  devel do
    url "https://www.percona.com/downloads/Percona-Server-5.7/Percona-Server-5.7.10-1rc1/source/tarball/percona-server-5.7.10-1rc1.tar.gz"
    version "5.7.10-1rc1"
    sha256 "68de79af4a761522f436b89eeb5bbb43a56dccc2bc352d38c79b6e6be0c4106c"

    resource "boost" do
      url "https://downloads.sourceforge.net/project/boost/boost/1.59.0/boost_1_59_0.tar.bz2"
      sha256 "727a932322d94287b62abb1bd2d41723eec4356a7728909e38adb65ca25241ca"
    end
  end

  bottle do
    revision 1
    sha256 "b283468128a1450e20c73ceb16f5d6454a2cb834b5f7b889118456d6f9693af6" => :el_capitan
    sha256 "56b11a60d823385bbe3f888d43d2780fbe7ae0ac96745ea624095480b96d0602" => :yosemite
    sha256 "aa6efe7ebbcdfa1a26530300da885f56a33d3132f953886cdbe309fb545da6ec" => :mavericks
  end

  option :universal
  option "with-test", "Build with unit tests"
  option "with-embedded", "Build the embedded server"
  option "with-memcached", "Build with InnoDB Memcached plugin"
  option "with-local-infile", "Build with local infile loading support"

  deprecated_option "enable-local-infile" => "with-local-infile"
  deprecated_option "with-tests" => "with-test"

  depends_on "cmake" => :build
  depends_on "pidof" unless MacOS.version >= :mountain_lion
  depends_on "openssl"

  conflicts_with "mysql-connector-c",
    :because => "both install `mysql_config`"

  conflicts_with "mariadb", "mysql", "mysql-cluster",
    :because => "percona, mariadb, and mysql install the same binaries."
  conflicts_with "mysql-connector-c",
    :because => "both install MySQL client libraries"
  conflicts_with "mariadb-connector-c",
    :because => "both install plugins"

  fails_with :llvm do
    build 2334
    cause "https://github.com/Homebrew/homebrew/issues/issue/144"
  end

  # Where the database files should be located. Existing installs have them
  # under var/percona, but going forward they will be under var/msyql to be
  # shared with the mysql and mariadb formulae.
  def datadir
    @datadir ||= (var/"percona").directory? ? var/"percona" : var/"mysql"
  end

  def pour_bottle?
    datadir == var/"mysql"
  end

  def install
    # Don't hard-code the libtool path. See:
    # https://github.com/Homebrew/homebrew/issues/20185
    inreplace "cmake/libutils.cmake",
      "COMMAND /usr/bin/libtool -static -o ${TARGET_LOCATION}",
      "COMMAND libtool -static -o ${TARGET_LOCATION}"

    # Build without compiler or CPU specific optimization flags to facilitate
    # compilation of gems and other software that queries `mysql-config`.
    ENV.minimal_optimization

    args = %W[
      -DCMAKE_INSTALL_PREFIX=#{prefix}
      -DCMAKE_FIND_FRAMEWORK=LAST
      -DCMAKE_VERBOSE_MAKEFILE=ON
      -DMYSQL_DATADIR=#{datadir}
      -DINSTALL_INCLUDEDIR=include/mysql
      -DINSTALL_MANDIR=share/man
      -DINSTALL_DOCDIR=share/doc/#{name}
      -DINSTALL_INFODIR=share/info
      -DINSTALL_MYSQLSHAREDIR=share/mysql
      -DWITH_SSL=yes
      -DDEFAULT_CHARSET=utf8
      -DDEFAULT_COLLATION=utf8_general_ci
      -DSYSCONFDIR=#{etc}
      -DCOMPILATION_COMMENT=Homebrew
      -DWITH_EDITLINE=system
      -DCMAKE_BUILD_TYPE=RelWithDebInfo
    ]

    # PAM plugin is Linux-only at the moment
    args.concat %W[
      -DWITHOUT_AUTH_PAM=1
      -DWITHOUT_AUTH_PAM_COMPAT=1
      -DWITHOUT_DIALOG=1
    ]

    # TokuDB is broken on MacOsX
    # https://bugs.launchpad.net/percona-server/+bug/1531446
    args.concat %W[-DWITHOUT_TOKUDB=1]

    if build.devel?
      # MySQL >5.7.x mandates Boost as a requirement to build & has a strict
      # version check in place to ensure it only builds against expected release.
      # This is problematic when Boost releases don't align with MySQL releases.
      (buildpath/"boost_1_59_0").install resource("boost")
      args << "-DWITH_BOOST=#{buildpath}/boost_1_59_0"
    end

    # To enable unit testing at build, we need to download the unit testing suite
    if build.with? "test"
      args << "-DENABLE_DOWNLOADS=ON"
    else
      args << "-DWITH_UNIT_TESTS=OFF"
    end

    # Build the embedded server
    args << "-DWITH_EMBEDDED_SERVER=ON" if build.with? "embedded"

    # Build with InnoDB Memcached plugin
    args << "-DWITH_INNODB_MEMCACHED=ON" if build.with? "memcached"

    # Make universal for binding to universal applications
    if build.universal?
      ENV.universal_binary
      args << "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.universal_archs.as_cmake_arch_flags}"
    end

    # Build with local infile loading support
    args << "-DENABLED_LOCAL_INFILE=1" if build.with? "local-infile"

    system "cmake", *args
    system "make"
    system "make", "install"

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

    # mysqlaccess deprecated on 5.6.17, and removed in 5.7.4.
    # See: https://bugs.mysql.com/bug.php?id=69012
    if build.stable?
      # Move mysqlaccess to libexec
      libexec.mkpath
      mv "#{bin}/mysqlaccess", libexec
      mv "#{bin}/mysqlaccess.conf", libexec
    end
  end

  def post_install
    # Make sure that data directory exists
    datadir.mkpath
    unless File.exist? "#{datadir}/mysql/user.frm"
      ENV["TMPDIR"] = nil
      system "#{bin}/mysql_install_db", "--verbose", "--user=#{ENV["USER"]}",
        "--basedir=#{prefix}", "--datadir=#{datadir}", "--tmpdir=/tmp"
    end
  end

  def caveats; <<-EOS.undent
    A "/etc/my.cnf" from another install may interfere with a Homebrew-built
    server starting up correctly.

    To connect:
        mysql -uroot
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
      <string>#{opt_bin}/mysqld_safe</string>
      <key>RunAtLoad</key>
      <true/>
      <key>WorkingDirectory</key>
      <string>#{var}</string>
    </dict>
    </plist>
    EOS
  end
end
