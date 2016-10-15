require 'formula'

class Gremlin < Formula
  homepage 'http://gremlin.tinkerpop.com'
  url 'http://tinkerpop.com/downloads/gremlin/gremlin-groovy-2.4.0.zip'
  sha1 'ee7979e2a0a773a41ca998d81d3712193d5f5403'
  head do
    url 'https://github.com/tinkerpop/gremlin.git', :branch => 'master'
    depends_on "maven" => :build
  end

  def install
    inreplace 'bin/gremlin.sh', '`dirname $0`/..', prefix
    inreplace 'bin/gremlin.sh', '/lib/', '/libexec/'
    if build.head?
      system 'mvn', 'clean', 'install'
    else
      bin.install 'bin/gremlin.sh' => 'gremlin'
      prefix.install 'data', 'doc'
      libexec.install Dir['lib/*']
    end
  end
end
