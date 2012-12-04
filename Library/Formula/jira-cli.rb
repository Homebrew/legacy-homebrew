require 'formula'


class JiraCli < Formula
  homepage 'https://bobswift.atlassian.net/wiki/display/JCLI/JIRA+Command+Line+Interface'
  url 'https://bobswift.atlassian.net/wiki/download/attachments/16285777/jira-cli-3.1.0-distribution.zip?api=v2'
  version '3.1.0'
  sha1 '4f50db300f01a753669360510e0e6cc63234c389'

  def script; <<-EOS.undent
    #!/bin/bash
    java -jar #{libexec}/jira-cli-3.1.0.jar --server ${JIRA_SERVER} --user ${JIRA_USER} --password ${JIRA_PASSWORD} "$@"
    EOS
  end

  def install
    rm_f Dir["*.bat"]
    libexec.install Dir["lib/*.jar"]
    (libexec+'jdbc').install Dir["lib/jdbc/*.jar"]
    prefix.install Dir["*"]
    (bin+'jira').write script
  end

  def caveats; <<-EOS.undent
    You need to set the following env variables before running:
        JIRA_SERVER
        JIRA_USER
        JIRA_PASSWORD

    From the command prompt, run:
        jira --help
    EOS
  end
end
