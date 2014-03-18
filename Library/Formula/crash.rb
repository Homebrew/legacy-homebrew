require 'formula'

class Crash < Formula
  homepage 'http://www.crashub.org/'
  url 'https://crsh.googlecode.com/files/crash-1.2.8.tar.gz'
  sha1 '12290cd227b20eae07674f8cf0d43ee58732e34b'

  devel do
    url 'http://search.maven.org/remotecontent?filepath=org/crashub/crash.distrib/1.3.0-beta15/crash.distrib-1.3.0-beta15.tar.gz'
    sha1 '1622804e40debec430a06e6354dcbff7b455741b'

    resource 'docs' do
      url 'http://search.maven.org/remotecontent?filepath=org/crashub/crash.distrib/1.3.0-beta15/crash.distrib-1.3.0-beta15-docs.tar.gz'
      version '1.3.0-beta15'
      sha1 'a4f37368b67c32d8021e023b3cb60ed671de4d8d'
    end
  end

  resource 'docs' do
    url 'https://crsh.googlecode.com/files/crash-1.2.8-docs.tar.gz'
    sha1 'ea385cf28c9c8fc0512d8809bf511c37a5be8e1a'
  end

  def install
    doc.install resource('docs')
    libexec.install Dir['crash/*']
    bin.install_symlink "#{libexec}/bin/crash.sh"
  end
end
