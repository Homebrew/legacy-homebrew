require 'formula'

class Crash < Formula
  homepage 'http://www.crashub.org/'
  url 'http://search.maven.org/remotecontent?filepath=org/crsh/crsh.distrib/1.2.9/crsh.distrib-1.2.9.tar.gz'
  sha1 '7e0f066ea398e76bdabe0ed715a4ac188597c4f4'

  devel do
    url 'http://search.maven.org/remotecontent?filepath=org/crashub/crash.distrib/1.3.0-beta18/crash.distrib-1.3.0-beta18.tar.gz'
    sha1 '0dfeda2da4b5fc4206f0cb481214ac83bb8696a5'

    resource 'docs' do
      url 'http://search.maven.org/remotecontent?filepath=org/crashub/crash.distrib/1.3.0-beta18/crash.distrib-1.3.0-beta18-docs.tar.gz'
      version '1.3.0-beta18'
      sha1 'a7c8cab9a85a8a0f24a318b05e6db175e00df931'
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
