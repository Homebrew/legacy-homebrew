require 'formula'

class X86_64_Architecture < Requirement
  def message; <<-EOS.undent
    Your system appears to run on a 32-bit architecture.
    Postgres-XC only supports 64-bit architectures, sorry.
    EOS
  end
  def satisfied?
    MacOS.prefer_64_bit?
  end
  def fatal?
    true
  end
end

class PostgresqlNotInstalled < Requirement
  def message; <<-EOS.undent
    You need to disable the postgresql formula with

      launchctl unload -w ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist
      brew unlink postgresql

    before installing Postgres-XC.
    EOS
  end
  def satisfied?
    not File.exists?("#{HOMEBREW_PREFIX}/bin/postgres")
  end
  def fatal?
    true
  end
end

class PostgresXc < Formula
  homepage 'http://postgres-xc.sourceforge.net/'
  url 'http://sourceforge.net/projects/postgres-xc/files/Version_1.0beta2/pgxc_v1.0beta2.tar.gz'
  version '1.0beta2'
  md5 'f97902f3ff787085a08d6b24a1d263e2'

  depends_on X86_64_Architecture.new
  depends_on PostgresqlNotInstalled.new
  depends_on 'readline'
  depends_on 'libxml2' if MacOS.leopard? # Leopard libxml is too old
  depends_on 'ossp-uuid'

  def options
    [
      ['--no-python', 'Build without Python support.'],
      ['--no-perl', 'Build without Perl support.'],
      ['--enable-dtrace', 'Build with DTrace support.']
    ]
  end

  skip_clean :all

  # The patch is needed to build on OS X. See:
  # http://sourceforge.net/mailarchive/forum.php?thread_name=CAAn2te_tCsdA%2BE0CWkhdGUQPnbsNCXec%3DMyQuZVws65sDb9e%2Bw%40mail.gmail.com&forum_name=postgres-xc-general
  def patches; DATA; end

  def install
    ENV.libxml2 if MacOS.snow_leopard?

    args = ["--disable-debug",
            "--prefix=#{prefix}",
            "--datadir=#{share}/#{name}",
            "--docdir=#{doc}",
            "--enable-thread-safety",
            "--with-bonjour",
            "--with-gssapi",
            "--with-krb5",
            "--with-openssl",
            "--with-libxml",
            "--with-libxslt",
            "--with-ossp-uuid"]

    args << "--with-python" unless ARGV.include? '--no-python'
    args << "--with-perl" unless ARGV.include? '--no-perl'
    args << "--enable-dtrace" if ARGV.include? '--enable-dtrace'
    args << "ARCHFLAGS='-arch x86_64'"

    ENV.append 'CFLAGS', `uuid-config --cflags`.strip
    ENV.append 'LDFLAGS', `uuid-config --ldflags`.strip
    ENV.append 'LIBS', `uuid-config --libs`.strip

    check_python_arch unless ARGV.include? '--no-python'

    # Fails on Core Duo with O4 and O3
    ENV.O2 if Hardware.intel_family == :core

    # Remove spurious compiled library (it must be built from source)
    rm_rf "src/gtm/path/libgtmpath.a"
    system "./configure", *args
    # We have to build contrib separately (as opposed to running "make world")
    # because "make world" depends on Jade being installed, as of v1.0.beta2.
    system "make"
    cd "contrib" do
      system "make"
    end
    system "make install"
    cd "contrib" do
      system "make install"
    end

    plist_path('gtm').write gtm_startup_plist('gtm')
    plist_path('gtm').chmod 0644
    plist_path('gtm_proxy').write gtm_proxy_startup_plist('gtm_proxy')
    plist_path('gtm_proxy').chmod 0644
    plist_path('coord1').write coordinator_startup_plist('coord1')
    plist_path('coord1').chmod 0644
    plist_path('datanode1').write datanode_startup_plist('datanode1')
    plist_path('datanode1').chmod 0644

    mkpath var+'postgres-xc' # Create data directory
  end

  def check_python_arch
    # On 64-bit systems, we need to look for a 32-bit Framework Python.
    # If the configure script prefers that Python version and if that version
    # doesn't have 64-bit support then linking will fail.
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
    Postgres-XC has four types of node servers:
    GTM, GTM-Proxy, Coordinator, and Datanode.

    ### GTM (Global Transaction Manager)

    If this is your first install, create GTM's working directory:

      initgtm -Z gtm -D #{var}/postgres-xc/gtm

    You may also want to edit

      #{var}/postgres-xc/gtm/gtm.conf

    to set at least the listen addresses and port.

    To load GTM automatically on login:

      mkdir -p ~/Library/LaunchAgents
      cp #{plist_path('gtm')} ~/Library/LaunchAgents/
      launchctl load -w ~/Library/LaunchAgents/#{plist_path('gtm').basename}

    Or start it manually with:

      gtm -D #{var}/postgres-xc/gtm

    If this is an upgrade and you already have the #{plist_path('gtm').basename} loaded:

      launchctl unload -w ~/Library/LaunchAgents/#{plist_path('gtm').basename}
      cp #{plist_path('gtm')} ~/Library/LaunchAgents/
      launchctl load -w ~/Library/LaunchAgents/#{plist_path('gtm').basename}

    ### GTM-Proxy

    If this is your first install, create GTM-Proxy's working directory:

      initgtm -Z gtm_proxy #{var}/postgres-xc/gtm_proxy

    You may also want to edit

      #{var}/postgres-xc/gtm_proxy/gtm_proxy.conf

    to set at least the listen addresses and port.

    To load GTM-Proxy automatically on login:

      mkdir -p ~/Library/LaunchAgents
      cp #{plist_path('gtm_proxy')} ~/Library/LaunchAgents/
      launchctl load -w ~/Library/LaunchAgents/#{plist_path('gtm_proxy').basename}

    Or start it manually with:

      gtm_proxy -D #{var}/postgres-xc/gtm_proxy -n 2 -s localhost -t 6666

    The above assumes that GTM is listening on the same machine on port 6666.
    You need to modify the command and the plist above if your GTM configuration
    is different.

    If this is an upgrade and you already have the #{plist_path('gtm_proxy').basename} loaded:

      launchctl unload -w ~/Library/LaunchAgents/#{plist_path('gtm_proxy').basename}
      cp #{plist_path('gtm_proxy')} ~/Library/LaunchAgents/
      launchctl load -w ~/Library/LaunchAgents/#{plist_path('gtm_proxy').basename}

    ### Coordinator

    If this is your first install, create a coordinator's working directory:
    (change 'coord1' as required):

      initdb -D #{var}/postgres-xc/coord1 --nodename coord1

    You may also want to edit

      #{var}/postgres-xc/coord1/postgresql.conf

    to set at least the listen addresses and port.

    To load the coordinator automatically on login:

      mkdir -p ~/Library/LaunchAgents
      cp #{plist_path('coord1')} ~/Library/LaunchAgents/
      launchctl load -w ~/Library/LaunchAgents/#{plist_path('coord1').basename}

    Or start it manually with:

      postgres -C -D #{var}/postgres-xc/coord1 -i

    If this is an upgrade and you already have the #{plist_path('coord1').basename} loaded:

      launchctl unload -w ~/Library/LaunchAgents/#{plist_path('coord1').basename}
      cp #{plist_path('coord1')} ~/Library/LaunchAgents/
      launchctl load -w ~/Library/LaunchAgents/#{plist_path('coord1').basename}

    ### Datanode

    If this is your first install, create a datanode's working directory:
    (change 'datanode1' as required):

      initdb -D #{var}/postgres-xc/datanode1 --nodename datanode1

    You may also want to edit

      #{var}/postgres-xc/datanode1/postgresql.conf

    to set at least the listen addresses and port.

    To load the datanode automatically on login:

      mkdir -p ~/Library/LaunchAgents
      cp #{plist_path('datanode1')} ~/Library/LaunchAgents/
      launchctl load -w ~/Library/LaunchAgents/#{plist_path('datanode1').basename}

    Or start it manually with:

      postgres -X -D #{var}/postgres-xc/datanode1 -i

    If this is an upgrade and you already have the #{plist_path('datanode1').basename} loaded:

      launchctl unload -w ~/Library/LaunchAgents/#{plist_path.basename}
      cp #{plist_path} ~/Library/LaunchAgents/
      launchctl load -w ~/Library/LaunchAgents/#{plist_path.basename}

    ### Other notes

    If you get the following error:
      FATAL:  could not create shared memory segment: Cannot allocate memory
    then you need to tweak your system's shared memory parameters:
      http://www.postgresql.org/docs/current/static/kernel-resources.html#SYSVIPC

    You may also need to edit the plists above to use the correct "UserName".

    If you launch more server processes on the same machine, you must make
    sure that they all listen on different ports.

    See also:
      http://sourceforge.net/projects/postgres-xc/files/Publication/start_pgxc_in_10_commands.txt
      http://postgres-xc.sourceforge.net/docs/1_0/runtime.html
    EOS
  end

  # Override Formula#plist_name
  def plist_name(extra = nil)
    (extra) ? super()+'-'+extra : super()
  end

  # Override Formula#plist_path
  def plist_path(extra = nil)
    (extra) ? super().dirname+(plist_name(extra)+'.plist') : super()
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
        <string>#{HOMEBREW_PREFIX}/bin/gtm</string>
        <string>-D</string>
        <string>#{var}/postgres-xc/#{name}</string>
        <string>-l</string>
        <string>#{var}/postgres-xc/#{name}/server.log</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>UserName</key>
      <string>#{`whoami`.chomp}</string>
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
        <string>#{HOMEBREW_PREFIX}/bin/gtm_proxy</string>
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
      <key>UserName</key>
      <string>#{`whoami`.chomp}</string>
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
        <string>#{HOMEBREW_PREFIX}/bin/postgres</string>
        <string>-i</string>
        <string>-C</string>
        <string>-D</string>
        <string>#{var}/postgres-xc/#{name}</string>
        <string>-r</string>
        <string>#{var}/postgres-xc/#{name}/server.log</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>UserName</key>
      <string>#{`whoami`.chomp}</string>
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
        <string>#{HOMEBREW_PREFIX}/bin/postgres</string>
        <string>-i</string>
        <string>-X</string>
        <string>-D</string>
        <string>#{var}/postgres-xc/#{name}</string>
        <string>-r</string>
        <string>#{var}/postgres-xc/#{name}/server.log</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>UserName</key>
      <string>#{`whoami`.chomp}</string>
      <key>WorkingDirectory</key>
      <string>#{HOMEBREW_PREFIX}</string>
      <key>StandardErrorPath</key>
      <string>#{var}/postgres-xc/#{name}/server.log</string>
    </dict>
    </plist>
    EOPLIST
  end

end


__END__
diff --git a/src/Makefile.shlib b/src/Makefile.shlib
index 983abc3..e393fc6 100644
--- a/src/Makefile.shlib
+++ b/src/Makefile.shlib
@@ -130,7 +130,7 @@ ifeq ($(PORTNAME), darwin)
     ifneq ($(SO_MAJOR_VERSION), 0)
       version_link	= -compatibility_version $(SO_MAJOR_VERSION) -current_version $(SO_MAJOR_VERSION).$(SO_MINOR_VERSION)
     endif
-    LINK.shared		= $(COMPILER) -dynamiclib -install_name '$(libdir)/lib$(NAME).$(SO_MAJOR_VERSION)$(DLSUFFIX)' $(version_link) $(exported_symbols_list) -multiply_defined suppress
+    LINK.shared		= $(COMPILER) -dynamiclib -install_name '$(libdir)/lib$(NAME).$(SO_MAJOR_VERSION)$(DLSUFFIX)' $(version_link) $(exported_symbols_list) -multiply_defined suppress -undefined suppress -flat_namespace
     shlib		= lib$(NAME).$(SO_MAJOR_VERSION).$(SO_MINOR_VERSION)$(DLSUFFIX)
     shlib_major		= lib$(NAME).$(SO_MAJOR_VERSION)$(DLSUFFIX)
   else
