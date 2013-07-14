require 'formula'

class SalesforceAnt < Formula
  homepage 'http://wiki.developerforce.com/page/Migration_Tool_Guide'
  url 'https://login.salesforce.com/dwnld/SfdcAnt/salesforce_ant_28.0.zip'
  sha1 '99c4e2aaec3d266dbbf15a7714a3a733604319ab'

  def install
    libexec.install 'ant-salesforce.jar'
  end
 
  def caveats; <<-EOS.undent
    To complete the installation, symlink ant-salesforce.jar into your ANT library directory:
      mkdir -p $HOME/.ant/lib
      ln -s #{HOMEBREW_PREFIX}/opt/#{name}/libexec/ant-salesforce.jar $HOME/.ant/lib/ant-salesforce.jar
    EOS
  end
 
  test do
    system "jar tf #{HOMEBREW_PREFIX}/opt/#{name}/libexec/ant-salesforce.jar | grep 'com/salesforce/antlib.xml'"
  end
end
