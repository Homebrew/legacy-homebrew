class Nikto < Formula
  desc "Web server scanner"
  homepage "http://cirt.net/nikto2"
  url "https://www.cirt.net/nikto/nikto-2.1.5.tar.bz2"
  sha256 "65b99c1fdec14d1d5e7cbc964f70fce162cbec50aee878e1500e2d22df079b34"

  def install
    inreplace "nikto.pl", "/etc/nikto.conf", "#{etc}/nikto.conf"

    inreplace "nikto.conf" do |s|
      s.gsub! "# EXECDIR=/opt/nikto", "EXECDIR=#{prefix}"
      s.gsub! "# PLUGINDIR=/opt/nikto/plugins", "PLUGINDIR=#{prefix}/plugins"
      s.gsub! "# DBDIR=/opt/nikto/databases", "DBDIR=#{var}/lib/nikto/databases"
      s.gsub! "# TEMPLATEDIR=/opt/nikto/templates", "TEMPLATEDIR=#{prefix}/templates"
      s.gsub! "# DOCDIR=/opt/nikto/docs", "DOCDIR=#{prefix}/docs"
    end

    bin.install "nikto.pl" => "nikto"
    etc.install "nikto.conf"
    man1.install "docs/nikto.1"
    share.install "docs"
    prefix.install "plugins", "templates"
    (var+"lib/nikto/databases").mkpath
  end

  def post_install
    system "#{bin}/nikto", "-update"
  end
end
