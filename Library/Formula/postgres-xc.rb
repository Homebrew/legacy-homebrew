class PostgresXc < Formula
  desc "PostgreSQL cluster based on shared-nothing architecture"
  homepage "http://postgres-xc.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/postgres-xc/Version_1.0/pgxc-v1.0.4.tar.gz"
  sha256 "b467cbb7d562a8545645182958efd1608799ed4e04a9c3906211878d477b29c1"

  bottle do
    sha256 "1a8e8d86ffbdce0287ed016a8fe98ab166097356c25db0796defb346d7bd77a6" => :el_capitan
    sha256 "6a96a35995306b0f3f32a5d3f3b4527d9bced585f828cc9dbec1ef8c29eb8790" => :yosemite
    sha256 "1f05cbe6cb40097c0e5fb7d3b62d32b5305dce2c364f018c830069e7ad1adcd9" => :mavericks
  end

  option "with-dtrace", "Build with DTrace support"
  option "without-perl", "Build without Perl support"

  deprecated_option "no-perl" => "without-perl"
  deprecated_option "enable-dtrace" => "with-dtrace"

  depends_on :arch => :x86_64
  depends_on "openssl"
  depends_on "readline"
  depends_on "libxml2" if MacOS.version <= :leopard # Leopard libxml is too old
  depends_on "ossp-uuid" => :recommended
  depends_on :python => :optional

  conflicts_with "postgresql",
    :because => "postgres-xc and postgresql install the same binaries."

  fails_with :clang do
    build 211
    cause "Miscompilation resulting in segfault on queries"
  end

  # Fix PL/Python build: https://github.com/Homebrew/homebrew/issues/11162
  # Fix uuid-ossp build issues: http://www.postgresql.org/message-id/05843630-E25D-442A-A6B0-5CA63622A400@likeness.com
  patch :DATA

  def install
    ENV.libxml2 if MacOS.version >= :snow_leopard

    # See https://sourceforge.net/mailarchive/forum.php?thread_name=82E44F89-543A-44F2-8AF8-F6909B5DC561%40uniud.it&forum_name=postgres-xc-bugs
    ENV.append "CFLAGS", "-D_FORTIFY_SOURCE=0 -O2" if MacOS.version >= :mavericks

    ENV.prepend "LDFLAGS", "-L#{Formula["openssl"].opt_lib} -L#{Formula["readline"].opt_lib}"
    ENV.prepend "CPPFLAGS", "-I#{Formula["openssl"].opt_include} -I#{Formula["readline"].opt_include}"

    args = %W[
      --disable-debug
      --prefix=#{prefix}
      --datadir=#{pkgshare}
      --docdir=#{doc}
      --enable-thread-safety
      --with-bonjour
      --with-gssapi
      --with-krb5
      --with-openssl
      --with-libxml
      --with-libxslt
    ]

    args << "--with-ossp-uuid" if build.with? "ossp-uuid"
    args << "--with-python" if build.with? "python"
    args << "--with-perl" if build.with? "perl"
    args << "--enable-dtrace" if build.with? "dtrace"
    args << "ARCHFLAGS='-arch x86_64'"

    if build.with? "ossp-uuid"
      ENV.append "CFLAGS", `uuid-config --cflags`.strip
      ENV.append "LDFLAGS", `uuid-config --ldflags`.strip
      ENV.append "LIBS", `uuid-config --libs`.strip
    end

    check_python_arch if build.with? "python"

    system "./configure", *args

    # Building the documentation looks for Jade or OpenJade, neither of which exist on OS X
    # or are supplied by Homebrew at this point in time. Disable for now, since error fatal.
    inreplace "GNUmakefile", "recurse,install-world,doc-xc src", "recurse,install-world,src"
    system "make", "install-world"

    plist_path("gtm").write gtm_startup_plist("gtm")
    plist_path("gtm").chmod 0644
    plist_path("gtm_proxy").write gtm_proxy_startup_plist("gtm_proxy")
    plist_path("gtm_proxy").chmod 0644
    plist_path("coord").write coordinator_startup_plist("coord")
    plist_path("coord").chmod 0644
    plist_path("datanode").write datanode_startup_plist("datanode")
    plist_path("datanode").chmod 0644
  end

  def post_install
    (var/"postgres-xc").mkpath
  end

  def check_python_arch
    # On 64-bit systems, we need to look for a 32-bit Framework Python.
    # The configure script prefers this Python version, and if it doesn't
    # have 64-bit support then linking will fail.
    framework_python = Pathname.new "/Library/Frameworks/Python.framework/Versions/Current/Python"
    return unless framework_python.exist?
    unless (archs_for_command framework_python).include? :x86_64
      opoo "Detected a framework Python that does not have 64-bit support in:"
      puts <<-EOS.undent
        #{framework_python}

        The configure script seems to prefer this version of Python over any others,
        so you may experience linker problems as described in:
          http://osdir.com/ml/pgsql-general/2009-09/msg00160.html

        To fix this issue, you may need to either delete the version of Python
        shown above, or move it out of the way before brewing PostgreSQL.

        Note that a framework Python in /Library/Frameworks/Python.framework is
        the "MacPython" version, and not the system-provided version which is in:
          /System/Library/Frameworks/Python.framework
      EOS
    end
  end

  def caveats; <<-EOS.undent
    To get started with Postgres-XC, read the documents at
      http://sourceforge.net/projects/postgres-xc/files/Publication/
      http://postgres-xc.sourceforge.net/docs/1_0/tutorial-start.html

    For a first cluster, you may start with a single GTM (Global Transaction Manager),
    a pair of Data Nodes and a single Coordinator, all on the same machine:

      initgtm -Z gtm -D #{var}/postgres-xc/gtm
      initdb -D #{var}/postgres-xc/datanode1 --nodename datanode1
      initdb -D #{var}/postgres-xc/datanode2 --nodename datanode2
      initdb -D #{var}/postgres-xc/coord --nodename coord

    Then edit:

      #{var}/postgres-xc/datanode1/postgresql.conf
      #{var}/postgres-xc/datanode2/postgresql.conf

    and change the port to 15432 and 15433, respectively.

    Then, launch the nodes and connect to the coordinator:

      gtm -D #{var}/postgres-xc/gtm -l #{var}/postgres-xc/gtm/server.log &
      postgres -i -X -D #{var}/postgres-xc/datanode1 -r #{var}/postgres-xc/datanode1/server.log &
      postgres -i -X -D #{var}/postgres-xc/datanode2 -r #{var}/postgres-xc/datanode2/server.log &
      postgres -i -C -D #{var}/postgres-xc/coord -r #{var}/postgres-xc/coord/server.log &
      psql postgres
        create node datanode1 with (type='datanode', port=15432);
        create node datanode2 with (type='datanode', port=15433);
        select * from pgxc_node;
        select pgxc_pool_reload();

    To shutdown everything, kill the processes in reverse order:

      kill -SIGTERM `head -1 #{var}/postgres-xc/coord/postmaster.pid`
      kill -SIGTERM `head -1 #{var}/postgres-xc/datanode1/postmaster.pid`
      kill -SIGTERM `head -1 #{var}/postgres-xc/datanode2/postmaster.pid`
      kill -SIGTERM `head -1 #{var}/postgres-xc/gtm/gtm.pid`

    If you get the following error:
      FATAL:  could not create shared memory segment: Cannot allocate memory
    then you need to tweak your system's shared memory parameters:
      http://www.postgresql.org/docs/current/static/kernel-resources.html#SYSVIPC
    EOS
  end

  # Override Formula#plist_name
  def plist_name(extra = nil)
    extra ? super()+"-"+extra : super()+"-gtm"
  end

  # Override Formula#plist_path
  def plist_path(extra = nil)
    extra ? super().dirname+(plist_name(extra)+".plist") : super()
  end

  def gtm_startup_plist(name); <<-EOPLIST.undent
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
        <string>#{opt_bin}/gtm</string>
        <string>-D</string>
        <string>#{var}/postgres-xc/#{name}</string>
        <string>-l</string>
        <string>#{var}/postgres-xc/#{name}/server.log</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>WorkingDirectory</key>
      <string>#{HOMEBREW_PREFIX}</string>
      <key>StandardErrorPath</key>
      <string>#{var}/postgres-xc/#{name}/server.log</string>
    </dict>
    </plist>
    EOPLIST
  end

  def gtm_proxy_startup_plist(name); <<-EOPLIST.undent
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
        <string>#{opt_bin}/gtm_proxy</string>
        <string>-D</string>
        <string>#{var}/postgres-xc/#{name}</string>
        <string>-n</string>
        <string>2</string>
        <string>-s</string>
        <string>localhost</string>
        <string>-t</string>
        <string>6666</string>
        <string>-l</string>
        <string>#{var}/postgres-xc/#{name}/server.log</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>WorkingDirectory</key>
      <string>#{HOMEBREW_PREFIX}</string>
      <key>StandardErrorPath</key>
      <string>#{var}/postgres-xc/#{name}/server.log</string>
    </dict>
    </plist>
    EOPLIST
  end

  def coordinator_startup_plist(name); <<-EOPLIST.undent
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
        <string>#{opt_bin}/postgres</string>
        <string>-i</string>
        <string>-C</string>
        <string>-D</string>
        <string>#{var}/postgres-xc/#{name}</string>
        <string>-r</string>
        <string>#{var}/postgres-xc/#{name}/server.log</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>WorkingDirectory</key>
      <string>#{HOMEBREW_PREFIX}</string>
      <key>StandardErrorPath</key>
      <string>#{var}/postgres-xc/#{name}/server.log</string>
    </dict>
    </plist>
    EOPLIST
  end

  def datanode_startup_plist(name); <<-EOPLIST.undent
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
        <string>#{opt_bin}/postgres</string>
        <string>-i</string>
        <string>-X</string>
        <string>-D</string>
        <string>#{var}/postgres-xc/#{name}</string>
        <string>-r</string>
        <string>#{var}/postgres-xc/#{name}/server.log</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>WorkingDirectory</key>
      <string>#{HOMEBREW_PREFIX}</string>
      <key>StandardErrorPath</key>
      <string>#{var}/postgres-xc/#{name}/server.log</string>
    </dict>
    </plist>
    EOPLIST
  end

  test do
    system "#{bin}/initdb", "--nodename=brew", testpath/"test"
    assert File.exist?("test")
  end
end


__END__
--- a/src/pl/plpython/Makefile	2011-09-23 08:03:52.000000000 +1000
+++ b/src/pl/plpython/Makefile	2011-10-26 21:43:40.000000000 +1100
@@ -24,8 +24,6 @@
 # Darwin (OS X) has its own ideas about how to do this.
 ifeq ($(PORTNAME), darwin)
 shared_libpython = yes
-override python_libspec = -framework Python
-override python_additional_libs =
 endif

 # If we don't have a shared library and the platform doesn't allow it
--- a/contrib/uuid-ossp/uuid-ossp.c	2012-07-30 18:34:53.000000000 -0700
+++ b/contrib/uuid-ossp/uuid-ossp.c	2012-07-30 18:35:03.000000000 -0700
@@ -9,6 +9,8 @@
  *-------------------------------------------------------------------------
  */

+#define _XOPEN_SOURCE
+
 #include "postgres.h"
 #include "fmgr.h"
 #include "utils/builtins.h"
