require 'formula'

class Crash < Formula
  homepage 'http://www.crashub.org/'
  url 'https://crsh.googlecode.com/files/crash-1.2.8.tar.gz'
  sha1 '12290cd227b20eae07674f8cf0d43ee58732e34b'

  devel do
    url 'http://search.maven.org/remotecontent?filepath=org/crashub/crash.distrib/1.3.0-beta17/crash.distrib-1.3.0-beta17.tar.gz'
    sha1 '2eecfc14fdcaa0b59e78a9e01b5da13e93c5b66c'

    resource 'docs' do
      url 'http://search.maven.org/remotecontent?filepath=org/crashub/crash.distrib/1.3.0-beta17/crash.distrib-1.3.0-beta17-docs.tar.gz'
      version '1.3.0-beta17'
      sha1 '73f5bd2a63ddbb8250cc406287e570d0cf42d36f'
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
