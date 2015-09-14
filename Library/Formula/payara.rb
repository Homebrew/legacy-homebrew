class Payara < Formula
  desc "Payara is 24/7 software support for GlassFish Server Open Source Edition"
  homepage "http://www.payara.co.uk/"
  url "https://github.com/payara/Payara/releases/download/payara-server-4.1.153/payara-4.1.153.zip"
  sha256 "52736b251b424280b1a4f19dd3522eb1fd1be12d0e2020a074c4872b898ef55c"

  depends_on :java => "1.7+"

  conflicts_with "glassfish", :because => "Both install `asadmin` binaries"

  def install
    rm_rf Dir["bin/*.bat"]
    rm "glassfish/config/asenv.bat"

    # Change to point to alternate domains and nodes directory
    inreplace "glassfish/config/asenv.conf" do |s|
      s.gsub! %r{AS_DEF_DOMAINS_PATH="../domains"}, "AS_DEF_DOMAINS_PATH=#{var}/payara/domains"
      s.gsub! %r{AS_DEF_NODES_PATH="../nodes"}, "AS_DEF_NODES_PATH=#{var}/payara/nodes"
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
    (var/"payara/nodes").mkpath
    # Make a copy of the domains folder if they do not exist yet
    unless (var/"payara/domains").exist?
      mv libexec/"glassfish/domains", "#{var}/payara"
    end
  end

  def caveats; <<-EOS.undent
    The home of Payara Application Server is:
      #{opt_libexec}

    Note: The support scripts used by Payara Application Server
    are *NOT* linked to bin.
  EOS
  end

  test do
    system bin/"asadmin", "--help"
  end
end
