require 'formula'

class Crash < Formula
  homepage 'http://www.crashub.org/'
  url 'http://search.maven.org/remotecontent?filepath=org/crsh/crsh.distrib/1.2.9/crsh.distrib-1.2.9.tar.gz'
  sha1 '7e0f066ea398e76bdabe0ed715a4ac188597c4f4'

  devel do
    url 'http://search.maven.org/remotecontent?filepath=org/crashub/crash.distrib/1.3.0-cr1/crash.distrib-1.3.0-cr1.tar.gz'
    version '1.3.0-cr1'
    sha1 '18786ae6a427b0630541b0cab7ec01c340e50bea'

    resource 'docs' do
      url 'http://search.maven.org/remotecontent?filepath=org/crashub/crash.distrib/1.3.0-cr1/crash.distrib-1.3.0-cr1-docs.tar.gz'
      version '1.3.0-cr1'
      sha1 '2cb3baeafaeda4a5a4e6d0d8c0a6d28db1ba7636'
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
