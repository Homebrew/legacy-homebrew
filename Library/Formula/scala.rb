require 'brewkit'

class Scala <Formula
  @homepage='http://www.gnu.org/software/wget/'
  @url='http://www.scala-lang.org/downloads/distrib/files/scala-2.7.5.final.tgz'
  @version='2.7.5'
  @md5='40a62c98d13689d83920f564a0532a8d'

  def install
    prefix.install Dir['*']
    FileUtils.mv prefix+'man', share
  end
end
