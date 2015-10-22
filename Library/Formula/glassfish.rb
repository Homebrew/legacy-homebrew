class Glassfish < Formula
  desc "Java EE application server"
  homepage "https://glassfish.java.net"
  url "http://download.java.net/glassfish/4.1.1/release/glassfish-4.1.1.zip"
  sha256 "1b20d42b7d97d0282b90b3f6ec958138f1e81a500468f391ff5aa06afb599b9c"

  depends_on :java => "1.7+"

  conflicts_with "payara", :because => "Both install `asadmin` binaries"

  def install
    rm_rf Dir["bin/*.bat"]
    rm "glassfish/config/asenv.bat"

    # Change to point to alternate domains and nodes directory
    inreplace "glassfish/config/asenv.conf" do |s|
      s.gsub! %r{AS_DEF_DOMAINS_PATH="../domains"}, "AS_DEF_DOMAINS_PATH=#{var}/glassfish/domains"
      s.gsub! %r{AS_DEF_NODES_PATH="../nodes"}, "AS_DEF_NODES_PATH=#{var}/glassfish/nodes"
    end

    libexec.install Dir["*", ".org.opensolaris,pkg"]
    (bin/"asadmin").write <<-EOS.undent
      #!/bin/sh
      AS_INSTALL="#{libexec}/glassfish"
      AS_INSTALL_LIB="$AS_INSTALL/lib"
      . "${AS_INSTALL}/config/asenv.conf"
      JAVA=java
      #Depends upon Java from ../config/asenv.conf
      if [ ${AS_JAVA} ]; then
        JAVA=${AS_JAVA}/bin/java
      fi
      exec "$JAVA" -jar "$AS_INSTALL_LIB/client/appserver-cli.jar" "$@"
    EOS
  end

  def post_install
    (var/"glassfish/nodes").mkpath
    # Make a copy of the domains folder if they do not exist yet
    unless (var/"glassfish/domains").exist?
      mv libexec/"glassfish/domains", "#{var}/glassfish"
    end
  end

  def caveats; <<-EOS.undent
    The home of GlassFish Application Server 4 is:
      #{opt_libexec}

    Starting up GlassFish requires root privileges as per
    https://java.net/jira/browse/GLASSFISH-21343.  The work around is
    to use
      sudo asadmin start-domain

    Note: The support scripts used by GlassFish Application Server 4
    are *NOT* linked to bin.
  EOS
  end

  test do
    system bin/"asadmin", "--help"
  end
end
