require 'formula'

class Crash < Formula
  homepage 'http://www.crashub.org/'
  url 'http://search.maven.org/remotecontent?filepath=org/crsh/crsh.distrib/1.2.9/crsh.distrib-1.2.9.tar.gz'
  sha1 '7e0f066ea398e76bdabe0ed715a4ac188597c4f4'

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
    url 'http://search.maven.org/remotecontent?filepath=org/crsh/crsh.distrib/1.2.9/crsh.distrib-1.2.9-docs.tar.gz'
    sha1 '134ebdb9b77f0916f73101154ea475e49ca57fe3'
  end

  def install
    doc.install resource('docs')
    libexec.install Dir['crash/*']
    bin.install_symlink "#{libexec}/bin/crash.sh"
  end
end
