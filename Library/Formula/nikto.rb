require 'formula'

class Nikto < Formula
  url 'https://cirt.net/nikto/nikto-2.1.4.tar.gz'
  homepage 'http://cirt.net/nikto2'
  md5 '8b9df0b08bbbcdf25b5ddec9e30b2633'

  def install
    inreplace 'nikto.pl' do |s|
      s.gsub! "/etc/nikto.conf", "#{bin}/nikto.conf"
    end
    inreplace 'nikto.conf' do |s|
      s.gsub! "# EXECDIR=/usr/local/nikto", "EXECDIR=#{bin}"
    end
    bin.install Dir['*']
  end

  def test
    system "nikto.pl"
  end
end
