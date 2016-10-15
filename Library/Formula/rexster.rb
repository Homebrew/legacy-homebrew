require 'formula'

class Rexster < Formula
  homepage 'http://rexster.tinkerpop.com'
  url 'http://tinkerpop.com/downloads/rexster/rexster-server-2.4.0.zip'
  sha1 '9fb8d7ac4c797f44bed03d9309479841b5430e50'
  head do
    url 'https://github.com/tinkerpop/rexster.git', :branch => 'master'
    depends_on "maven" => :build
  end

  def install
    inreplace 'bin/rexster.sh', '`dirname $0`/..', prefix
    inreplace 'bin/rexster.sh', '/lib/', '/libexec/'
    if build.head?
      system 'mvn', 'clean', 'install'
    else
      bin.install 'bin/rexster.sh' => bin/'rexster'
      prefix.install 'config', 'data', 'doc', 'ext', 'public'
      libexec.install Dir['lib/*']
    end
  end

  def caveats
    <<-EOS.undent
      NOTE:
      To start rexster, run 'rexster -s -c #{prefix}/config/rexster.xml'
    EOS
  end
end
