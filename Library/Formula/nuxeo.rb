class Nuxeo < Formula
  desc "Nuxeo Platform - Enterprise Content Management"
  homepage "https://nuxeo.github.io/"
  url "http://community.nuxeo.com/static/releases/nuxeo-7.10/nuxeo-cap-7.10-tomcat.zip"
  version "7.10"
  sha256 "9e95fb4e3dd0fdac49395ae8b429c6cc7db3c621ecd4d0dff74ea706a2aba723"

  depends_on "poppler" => :recommended
  depends_on "pdftohtml" => :optional
  depends_on "imagemagick"
  depends_on "ghostscript"
  depends_on "ufraw"
  depends_on "libwpd"
  depends_on "ffmpeg" => :optional

  def install
    libexec.install Dir["#{buildpath}/*"]

    bin.mkpath
    libexec.mkpath

    # link binary
    bin.install_symlink "#{libexec}/bin/nuxeoctl"
    # Inreplace Homebrew' paths to be independant from env variables
    inreplace "#{libexec}/bin/nuxeoctl" do |s|
      s.gsub! /\${NUXEO_HOME:=.*$/, '${NUXEO_HOME:=$(cd "$(dirname `PRG=$0; while [ -h "$PRG" ] ;do ls=\\\\`ls -ld "$PRG"\\\\`; link=\\\\`expr "$ls" : ".*-> \\\\(.*\)\$"\\\\`; if expr "$link" : "/.*" &> /dev/null; then PRG="$link"; else PRG="\\\\`dirname "$PRG"\\\\`/$link"; fi; done; echo $PRG`)"/..; pwd -P)}'
      s.gsub! /\${NUXEO_CONF:=.*$/, "${NUXEO_CONF:=\"#{etc}/nuxeo.conf\"}"
    end

    # Initiatialize var dir
    var_nuxeo = "#{var}/nuxeo"
    unless Dir.exist?(var_nuxeo)
      mkdir_p(var_nuxeo)
    end

    # Move data folder if not exists yet
    unless Dir.exist?("#{var_nuxeo}/data")
      mv(libexec/"nxserver/data", "#{var_nuxeo}/data")
    end

    unless File.exist?("#{etc}/nuxeo.conf")
      # Change default path to Homebrew ones
      inreplace "#{libexec}/bin/nuxeo.conf" do |s|
        s.gsub! /#nuxeo\.log\.dir.*/, "nuxeo.log.dir=#{var_nuxeo}/log"
        s.gsub! /#nuxeo\.data\.dir.*/, "nuxeo.data.dir=#{var_nuxeo}/data"
        s.gsub! /#nuxeo\.tmp\.dir.*/, "nuxeo.tmp.dir=/tmp/nuxeo"
      end

      cp("#{libexec}/bin/nuxeo.conf", "#{etc}/nuxeo.conf")
    end
  end

  def caveats; <<-EOS.undent
    Nuxeo installed.

    Configuration:
      Data folder: #{var}/nuxeo/data
      Log folder: #{var}/nuxeo/log
      nuxeo.conf file: #{etc}/nuxeo.conf

    Start Nuxeo:
      $ nuxeoctl start
  EOS
  end

  test do
    # Copy configuration file to test path, due to some automatic writes on it.
    cp("#{etc}/nuxeo.conf", "#{testpath}/nuxeo.conf")
    ENV['NUXEO_CONF'] = "#{testpath}/nuxeo.conf"

    # Ensure nuxeoctl is running fine
    system "#{bin}/nuxeoctl", "showconf"
  end
end
