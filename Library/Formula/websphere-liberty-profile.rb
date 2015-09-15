class WebsphereLibertyProfile < Formula
  desc "WebSphere Liberty Profile"
  homepage "https://developer.ibm.com/wasdev/websphere-liberty/"
  url "https://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/wasdev/downloads/wlp/8.5.5.7/wlp-javaee7-8.5.5.7.zip"
  sha256 "77f710c93cfd45661782d9895d5a17caa751a4186003753044e06b730d380bba"

  depends_on :java => "1.7+"

  def install
    rm_rf Dir["bin/*.bat"]
    rm_rf "usr"
    rmdir "usr"

    binaries = %w[binaryLog collective ddlGen installUtility securityUtility serverSchemaGen client configUtility featureManager isadc productInfo server]
    # Replace to specify the install path directly
    #
    # WLP_INSTALL_DIR=`unset CDPATH; cd "$dirname/../" && pwd`
    # or
    # WLP_INSTALL_DIR=`unset CDPATH; cd "$dirname/.." && pwd`

    binaries.each do |name|
      inreplace "bin/#{name}" do |s|
        s.gsub! %r{WLP_INSTALL_DIR=`unset CDPATH; cd \"\$dirname/\.\./?\" && pwd`}, "WLP_INSTALL_DIR=#{libexec}"
      end
    end

    libexec.install Dir["*"]

    # do not use bin.install because IDE integration may require the path to the scripts be in the same place.
    binaries.each do |name|
      bin.install_symlink "#{libexec}/bin/#{name}"
    end
  end

  def post_install
    # create a link for the usr folder which contains the files that should be persisted between re-installs
    (var/"websphere-liberty-profile/servers").mkpath
    (var/"websphere-liberty-profile/shared/apps").mkpath
    (var/"websphere-liberty-profile/shared/config").mkpath
    (var/"websphere-liberty-profile/shared/resources").mkpath
    ln_s "#{var}/websphere-liberty-profile", "#{libexec}/usr"
  end

  def caveats; <<-EOS.undent
    Create a server

      server create testServer

    Start server

      server start testServer

    Stop server

      server stop testServer
  EOS
  end

  test do
    # Ideally this would be following the steps noted in caveats
    #
    # system bin/"server", "create", "testServer"
    # system bin/"server", "start", "testServer"
    # system bin/"server", "stop", "testServer"
    # rm_rf "#{libexec}/usr/servers/testServer"
    #
    # However, that would fail on --sandbox mode because the data is in var
    system bin/"server", "list"
  end
end
