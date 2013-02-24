require 'formula'

class StanfordParser < Formula
  homepage 'http://nlp.stanford.edu/software/lex-parser.shtml'
  url 'http://nlp.stanford.edu/software/stanford-parser-2012-07-09.tgz'
  sha1 'd63f50b992eb563f3ab303b103984e8b9864b5ed'
  version '2.0.3'

  def install
    libexec.install Dir['*']
    bin.write_exec_script Dir["#{libexec}/*.sh"]
  end

  def test
    system "#{bin}/lexparser.sh", "#{libexec}/data/testsent.txt"
  end
end
