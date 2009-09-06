require 'brewkit'

# TODO common aliases: ant

class ApacheAnt <Formula
  @url='http://www.ibiblio.org/pub/mirrors/apache/ant/binaries/apache-ant-1.7.1-bin.tar.gz'
  @homepage='http://ant.apache.org/'
  @md5='cc5777c57c4e8269be5f3d1dc515301c'
  @version='1.7.1'

  def install
    prefix.install Dir['*']
  end
end
