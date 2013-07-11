require 'formula'

class SalesforceAnt < Formula
  homepage 'http://wiki.developerforce.com/page/Migration_Tool_Guide'
  url 'https://login.salesforce.com/dwnld/SfdcAnt/salesforce_ant_28.0.zip'
  sha1 '99c4e2aaec3d266dbbf15a7714a3a733604319ab'

  depends_on 'ant'

  def install
    libexec.install 'ant-salesforce.jar'
    system "ln -sf /usr/local/opt/salesforce_ant/libexec/ant-salesforce.jar /usr/local/opt/ant/libexec/lib/ant-salesforce.jar"
  end

  test do
    system "ant -diagnostics | grep -E 'ant-salesforce.jar \\([1-9]\\d+ bytes\\)'"
  end
end
