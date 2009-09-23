require 'brewkit'

class Scala <Formula
  @homepage='http://www.scala-lang.org/'
  @url='http://www.scala-lang.org/downloads/distrib/files/scala-2.7.6.final.tgz'
  @version='2.7.6'
  @md5='82934acf64d0c026de78b84e984f6743'

  def install
    prefix.install Dir['*']
    FileUtils.mv prefix+'man', share
  end
end
