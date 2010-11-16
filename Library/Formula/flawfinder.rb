require 'formula'

class Flawfinder < Formula
  url 'http://www.dwheeler.com/flawfinder/flawfinder-1.27.tar.gz'
  homepage 'http://www.dwheeler.com/flawfinder/'
  md5 '50fff67dd439f42b785577ed8b3a3f7d'

  def install
    system "mv makefile makefile.dist"
    system <<-EOF
sed "s/\\(^INSTALL_DIR=\\)\\(.*$\\)/\\1#{prefix.to_s.gsub(/\//,'\/')}/" makefile.dist | 
sed "s/\\(^INSTALL_DIR_MAN=\\)\\(.*$\\)/\\1#{prefix.to_s.gsub(/\//,'\/')}\\/share\\/man\\/man1\\//" &> makefile
EOF
    system "make install"
  end
end
