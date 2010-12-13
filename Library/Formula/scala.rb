require 'formula'

class Scala <Formula
  homepage 'http://www.scala-lang.org/'
  url 'http://www.scala-lang.org/downloads/distrib/files/scala-2.8.1.final.tgz'
  version '2.8.1'
  md5 '4fa66742341b5c9f6877ce64d409cb92'

  def install
    rm_f Dir["bin/*.bat"]
    doc.install Dir['doc/*']
    man1.install Dir['man/man1/*']
    libexec.install Dir['*']
    bin.mkpath
    Dir["#{libexec}/bin/*"].each { |f| ln_s f, bin }
  end
end
