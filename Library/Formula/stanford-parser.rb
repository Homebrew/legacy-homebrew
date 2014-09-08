require 'formula'

class StanfordParser < Formula
  homepage 'http://nlp.stanford.edu/software/lex-parser.shtml'
  url 'http://nlp.stanford.edu/software/stanford-parser-full-2014-06-16.zip'
  sha1 'cde955fd17803e58b9bffd83983748ef57e7862d'
  version '3.4'

  def install
    libexec.install Dir['*']
    bin.write_exec_script Dir["#{libexec}/*.sh"]
  end

  test do
    system "#{bin}/lexparser.sh", "#{libexec}/data/testsent.txt"
  end
end
