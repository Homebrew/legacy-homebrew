class Mariadb < Formula
  desc "Drop-in replacement for MySQL"
  homepage "https://mariadb.org/"
  url "http://ftp.osuosl.org/pub/mariadb/mariadb-10.1.10/source/mariadb-10.1.10.tar.gz"
  sha256 "d2c26fc76ff7397bdf25924161174c30a2b7fbd59893048f50145fc0a8278f76"

  bottle do
    revision 1
    sha256 "2669ef85cebf9da3676d2518d2ed263011f679f7c549b300615e32065a6d0a40" => :el_capitan
    sha256 "cf34d15fd602c94263484e27abb33a47ee29244049e77230296aaf32cd4fd517" => :yosemite
    sha256 "311ae3fe40c5cf25c5ea57bf5d3de40a1a8eb6eb51b424fde1596a03f471c585" => :mavericks
  end

  option :universal
  option "with-tests", "Keep test when installing"
  option "with-bench", "Keep benchmark app when installing"
  option "with-embedded", "Build the embedded server"
  option "with-libedit", "Compile with editline wrapper instead of readline"
  option "with-archive-storage-engine", "Compile with the ARCHIVE storage engine enabled"
  option "with-blackhole-storage-engine", "Compile with the BLACKHOLE storage engine enabled"
  option "with-local-infile", "Build with local infile loading support"

  deprecated_option "enable-local-infile" => "with-local-infile"

  depends_on "cmake" => :build
  depends_on "pidof" unless MacOS.version >= :mountain_lion
  depends_on "openssl"

  conflicts_with "mysql", "mysql-cluster", "percona-server",
    :because => "mariadb, mysql, and percona install the same binaries."
  conflicts_with "mysql-connector-c",
    :because => "both install MySQL client libraries"
  conflicts_with "mytop", :because => "both install `mytop` binaries"
  conflicts_with "mariadb-connector-c",
    :because => "both install plugins"

  patch do
    # fix compilation error https://mariadb.atlassian.net/browse/MDEV-9322
    # fixed in 10.1.11
    url "https://github.com/Buggynours/MariaDB/commit/3e76d54b98e328768b1999344c0affc7a8f04b69.patch"
    sha256 "78b32a1628ed7b2ea30c4a7fdf876d3e05db2cfe7bfa5a286aa213afda4b37b2"
  end

  def install
    # Don't hard-code the libtool path. See:
    # https://github.com/Homebrew/homebrew/issues/20185
    inreplace "cmake/libutils.cmake",
      "COMMAND /usr/bin/libtool -static -o ${TARGET_LOCATION}",
      "COMMAND libtool -static -o ${TARGET_LOCATION}"

    # Set basedir and ldata so that mysql_install_db can find the server
    # without needing an explicit path to be set. This can still
    # be overridden by calling --basedir= when calling.
    inreplace "scripts/mysql_install_db.sh" do |s|
      s.change_make_var! "basedir", "\"#{prefix}\""
      s.change_make_var! "ldata", "\"#{var}/mysql\""
    end

    # Build without compiler or CPU specific optimization flags to facilitate
    # compilation of gems and other software that queries `mysql-config`.
    ENV.minimal_optimization

    # -DINSTALL_* are relative to prefix
    args = %W[
      .
      -DCMAKE_INSTALL_PREFIX=#{prefix}
      -DCMAKE_FIND_FRAMEWORK=LAST
      -DCMAKE_VERBOSE_MAKEFILE=ON
      -DMYSQL_DATADIR=#{var}/mysql
      -DINSTALL_INCLUDEDIR=include/mysql
      -DINSTALL_MANDIR=share/man
      -DINSTALL_DOCDIR=share/doc/#{name}
      -DINSTALL_INFODIR=share/info
      -DINSTALL_MYSQLSHAREDIR=share/mysql
      -DWITH_SSL=yes
      -DDEFAULT_CHARSET=utf8
      -DDEFAULT_COLLATION=utf8_general_ci
      -DINSTALL_SYSCONFDIR=#{etc}
      -DCOMPILATION_COMMENT=Homebrew
    ]

    # disable TokuDB, which is currently not supported on Mac OS X
    args << "-DPLUGIN_TOKUDB=NO"

    args << "-DWITH_UNIT_TESTS=OFF" if build.without? "tests"

    # Build the embedded server
    args << "-DWITH_EMBEDDED_SERVER=ON" if build.with? "embedded"

    # Compile with readline unless libedit is explicitly chosen
    args << "-DWITH_READLINE=yes" if build.without? "libedit"

    # Compile with ARCHIVE engine enabled if chosen
    args << "-DPLUGIN_ARCHIVE=YES" if build.with? "archive-storage-engine"

    # Compile with BLACKHOLE engine enabled if chosen
    args << "-DPLUGIN_BLACKHOLE=YES" if build.with? "blackhole-storage-engine"

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

    # Fix my.cnf to point to #{etc} instead of /etc
    (etc+"my.cnf.d").mkpath
    inreplace "#{etc}/my.cnf" do |s|
      s.gsub!("!includedir /etc/my.cnf.d", "!includedir #{etc}/my.cnf.d")
    end
    touch etc/"my.cnf.d/.homebrew_dont_prune_me"

    # Don't create databases inside of the prefix!
    # See: https://github.com/Homebrew/homebrew/issues/4975
    rm_rf prefix+"data"

    (prefix+"mysql-test").rmtree if build.without? "tests" # save 121MB!
    (prefix+"sql-bench").rmtree if build.without? "bench"

    # Link the setup script into bin
    bin.install_symlink prefix/"scripts/mysql_install_db"

    # Fix up the control script and link into bin
    inreplace "#{prefix}/support-files/mysql.server" do |s|
      s.gsub!(/^(PATH=".*)(")/, "\\1:#{HOMEBREW_PREFIX}/bin\\2")
      # pidof can be replaced with pgrep from proctools on Mountain Lion
      s.gsub!(/pidof/, "pgrep") if MacOS.version >= :mountain_lion
    end

    bin.install_symlink prefix/"support-files/mysql.server"

    # Move sourced non-executable out of bin into libexec
    libexec.mkpath
    libexec.install "#{bin}/wsrep_sst_common"
    # Fix up references to wsrep_sst_common
    %W[
      wsrep_sst_mysqldump
      wsrep_sst_rsync
      wsrep_sst_xtrabackup
      wsrep_sst_xtrabackup-v2
    ].each do |f|
      inreplace "#{bin}/#{f}" do |s|
        s.gsub!("$(dirname $0)/wsrep_sst_common", "#{libexec}/wsrep_sst_common")
      end
    end
  end

  def post_install
    # Make sure the var/mysql directory exists
    (var+"mysql").mkpath
    unless File.exist? "#{var}/mysql/mysql/user.frm"
      ENV["TMPDIR"] = nil
      system "#{bin}/mysql_install_db", "--verbose", "--user=#{ENV["USER"]}",
        "--basedir=#{prefix}", "--datadir=#{var}/mysql", "--tmpdir=/tmp"
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
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/mysqld_safe</string>
        <string>--bind-address=127.0.0.1</string>
        <string>--datadir=#{var}/mysql</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>WorkingDirectory</key>
      <string>#{var}</string>
    </dict>
    </plist>
    EOS
  end

  test do
    if build.with? "tests"
      (prefix+"mysql-test").cd do
        system "./mysql-test-run.pl", "status"
      end
    else
      system "mysqld", "--version"
    end
  end
end
