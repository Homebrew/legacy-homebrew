class Nuxeo < Formula
  desc "Enterprise Content Management"
  homepage "https://nuxeo.github.io/"
  url "http://cdn.nuxeo.com/nuxeo-7.10/nuxeo-cap-7.10-tomcat.zip"
  version "7.10"
  sha256 "9e95fb4e3dd0fdac49395ae8b429c6cc7db3c621ecd4d0dff74ea706a2aba723"

  depends_on "poppler" => :recommended
  depends_on "pdftohtml" => :optional
  depends_on "imagemagick"
  depends_on "ghostscript"
  depends_on "ufraw"
  depends_on "libwpd"
  depends_on "exiftool"
  depends_on "ffmpeg" => :optional

  def install
    libexec.install Dir["#{buildpath}/*"]

    bin.mkpath
    bin.install_symlink "#{libexec}/bin/nuxeoctl"

    # TODO: https://jira.nuxeo.com/browse/NXBT-966 Use a wrapper
    inreplace "#{libexec}/bin/nuxeoctl" do |s|
      # See https://jira.nuxeo.com/browse/NXP-18418 nuxeoctl symlink is not correctly resolved and breaks NUXEO_HOME resolution.
      s.gsub! /\${NUXEO_HOME:=.*$/, '${NUXEO_HOME:=$(cd "$(dirname `PRG=$0; while [ -h "$PRG" ] ;do ls=\\\\`ls -ld "$PRG"\\\\`; link=\\\\`expr "$ls" : ".*-> \\\\(.*\)\$"\\\\`; if expr "$link" : "/.*" &> /dev/null; then PRG="$link"; else PRG="\\\\`dirname "$PRG"\\\\`/$link"; fi; done; echo $PRG`)"/..; pwd -P)}'
      s.gsub! /\${NUXEO_CONF:=.*$/, "${NUXEO_CONF:=\"#{etc}/nuxeo.conf\"}"
    end

    inreplace "#{libexec}/bin/nuxeo.conf" do |s|
      s.gsub! /#nuxeo\.log\.dir.*/, "nuxeo.log.dir=#{var}/log/nuxeo"
      s.gsub! /#nuxeo\.data\.dir.*/, "nuxeo.data.dir=#{var}/lib/nuxeo/data"
      s.gsub! /#nuxeo\.tmp\.dir.*/, "nuxeo.tmp.dir=/tmp/nuxeo"
      s.gsub! /#nuxeo\.pid\.dir.*/, "nuxeo.pid.dir=#{var}/run/nuxeo"
    end
    etc.install "#{libexec}/bin/nuxeo.conf"
  end

  def caveats; <<-EOS.undent
    You need to edit #{etc}/nuxeo.conf file to configure manually the server.
    In case of upgrade, use 'nuxeoctl mp-list' against the old version then 'nuxeoctl mp-set' on the new version to reinstall packages.
    EOS
  end

  test do
    # Copy configuration file to test path, due to some automatic writes on it.
    cp("#{etc}/nuxeo.conf", "#{testpath}/nuxeo.conf")
    inreplace "#{testpath}/nuxeo.conf" do |s|
      s.gsub! /#{var}/, testpath
    end
    ENV["NUXEO_CONF"] = "#{testpath}/nuxeo.conf"

    assert_equal "#{testpath}/nuxeo.conf", shell_output("#{bin}/nuxeoctl config -q --get nuxeo.conf").strip
    assert_equal "#{libexec}", shell_output("#{bin}/nuxeoctl config -q --get nuxeo.home").strip
  end
end
