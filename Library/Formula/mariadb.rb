class Mariadb < Formula
  desc "Drop-in replacement for MySQL"
  homepage "https://mariadb.org/"
  url "http://ftp.osuosl.org/pub/mariadb/mariadb-10.0.21/source/mariadb-10.0.21.tar.gz"
  sha256 "4b9a32e15ceadefdb1057a02eb3e0addf702b75aef631a3c9194b832ecfa3545"

  bottle do
    revision 1
    sha256 "56c8d14b15028b642705bf07d52be067b899c1431a71c67c4329d40a89ac4f31" => :el_capitan
    sha256 "4e762c7031ed3d1b2379933a000da2d28f6fdb25bcfa502c4b63a57cd9af3827" => :yosemite
    sha256 "e5e7570fd78781c7f77c73db91d8246091bc6e9e074cd52df59d7a42c8d6db43" => :mavericks
  end

  devel do
    url "http://ftp.osuosl.org/pub/mariadb/mariadb-10.1.7/source/mariadb-10.1.7.tar.gz"
    sha256 "5bd3b80cf0f312751271a3446c12579c7081f93406e59a0cdfda8e133423c88f"
    # fix compilation failure with clang in mroonga storage engine
    # https://mariadb.atlassian.net/projects/MDEV/issues/MDEV-8551
    patch :DATA
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
    if build.stable?
      args << "-DWITHOUT_TOKUDB=1"
    else
      args << "-DPLUGIN_TOKUDB=NO"
    end

    args << "-DWITH_UNIT_TESTS=OFF" if build.without? "tests"

    # Build the embedded server
    args << "-DWITH_EMBEDDED_SERVER=ON" if build.with? "embedded"

    # Compile with readline unless libedit is explicitly chosen
    args << "-DWITH_READLINE=yes" if build.without? "libedit"

    # Compile with ARCHIVE engine enabled if chosen
    if build.with? "archive-storage-engine"
      if build.stable?
        args << "-DWITH_ARCHIVE_STORAGE_ENGINE=1"
      else
        args << "-DPLUGIN_ARCHIVE=YES"
      end
    end

    # Compile with BLACKHOLE engine enabled if chosen
    if build.with? "blackhole-storage-engine"
      if build.stable?
        args << "-DWITH_BLACKHOLE_STORAGE_ENGINE=1"
      else
        args << "-DPLUGIN_BLACKHOLE=YES"
      end
    end

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

    if build.devel?
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
__END__
diff --git a/storage/mroonga/vendor/groonga/CMakeLists.txt b/storage/mroonga/vendor/groonga/CMakeLists.txt
index ebe7f6b..609f77d 100644
--- a/storage/mroonga/vendor/groonga/CMakeLists.txt
+++ b/storage/mroonga/vendor/groonga/CMakeLists.txt
@@ -192,6 +192,10 @@ if(CMAKE_COMPILER_IS_GNUCXX)
   check_build_flag("-Wno-clobbered")
 endif()

+if(CMAKE_COMPILER_IS_CLANGCXX)
+  MY_CHECK_AND_SET_COMPILER_FLAG("-fexceptions")
+endif()
+
 if(NOT DEFINED CMAKE_C_COMPILE_OPTIONS_PIC)
   # For old CMake
   if(CMAKE_COMPILER_IS_GNUCXX OR CMAKE_COMPILER_IS_CLANGCXX)
