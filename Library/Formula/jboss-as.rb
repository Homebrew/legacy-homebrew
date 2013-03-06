require 'formula'

class JbossAs < Formula
  homepage 'http://www.jboss.org/jbossas'
  url 'http://download.jboss.org/jbossas/7.1/jboss-as-7.1.1.Final/jboss-as-7.1.1.Final.tar.gz'
  version '7.1.1.Final'
  sha1 'fcec1002dce22d3281cc08d18d0ce72006868b6f'

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install Dir['*']
  end
end
