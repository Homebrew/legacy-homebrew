class Nuxeo < Formula
  desc "Enterprise Content Management"
  homepage "https://nuxeo.github.io/"
  url "http://cdn.nuxeo.com/nuxeo-7.10/nuxeo-cap-7.10-tomcat.zip"
  version "7.10"
  sha256 "9e95fb4e3dd0fdac49395ae8b429c6cc7db3c621ecd4d0dff74ea706a2aba723"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "50177b32b89be08ddfbd0ae6968f0148cd601d4953fbd74ac6c886abe3259124" => :el_capitan
    sha256 "cc330d3b501d4cd7364cbde348b843c1a8bdf8d81bbc303396c96c6910776320" => :yosemite
    sha256 "f093436e8aac5ce6401529930cfbdb11269c99f521ede970a9d9aaaacca5f152" => :mavericks
  end

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

    (bin/"nuxeoctl").write_env_script "#{libexec}/bin/nuxeoctl",
      :NUXEO_HOME => libexec.to_s, :NUXEO_CONF => "#{etc}/nuxeo.conf"

    inreplace "#{libexec}/bin/nuxeo.conf" do |s|
      s.gsub! /#nuxeo\.log\.dir.*/, "nuxeo.log.dir=#{var}/log/nuxeo"
      s.gsub! /#nuxeo\.data\.dir.*/, "nuxeo.data.dir=#{var}/lib/nuxeo/data"
      s.gsub! /#nuxeo\.pid\.dir.*/, "nuxeo.pid.dir=#{var}/run/nuxeo"
    end
    etc.install "#{libexec}/bin/nuxeo.conf"
  end

  def post_install
    (var/"log/nuxeo").mkpath
    (var/"lib/nuxeo/data").mkpath
    (var/"run/nuxeo").mkpath
    (var/"cache/nuxeo/packages").mkpath

    libexec.install_symlink var/"cache/nuxeo/packages"
  end

  def caveats; <<-EOS.undent
    You need to edit #{etc}/nuxeo.conf file to configure manually the server.
    Also, in case of upgrade, run 'nuxeoctl mp-upgrade' to ensure all
    downloaded addons are up to date.
    EOS
  end

  test do
    # Copy configuration file to test path, due to some automatic writes on it.
    cp "#{etc}/nuxeo.conf", "#{testpath}/nuxeo.conf"
    inreplace "#{testpath}/nuxeo.conf" do |s|
      s.gsub! /#{var}/, testpath
      s.gsub! /#nuxeo\.tmp\.dir.*/, "nuxeo.tmp.dir=#{testpath}/tmp"
    end

    ENV["NUXEO_CONF"] = "#{testpath}/nuxeo.conf"

    assert_match %r{#{testpath}/nuxeo\.conf}, shell_output("#{libexec}/bin/nuxeoctl config -q --get nuxeo.conf")
    assert_match /#{libexec}/, shell_output("#{libexec}/bin/nuxeoctl config -q --get nuxeo.home")
  end
end
