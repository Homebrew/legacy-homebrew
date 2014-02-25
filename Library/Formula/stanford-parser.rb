require 'formula'

class StanfordParser < Formula
  homepage 'http://nlp.stanford.edu/software/lex-parser.shtml'
  url 'http://nlp.stanford.edu/software/stanford-parser-full-2013-06-20.zip'
  sha1 'd22f3350b608e905e432b9278a5fa85c380cac30'
  version '3.2.0'

  def install
    libexec.install Dir['*']
    bin.write_exec_script Dir["#{libexec}/*.sh"]
  end

  test do
    system "#{bin}/lexparser.sh", "#{libexec}/data/testsent.txt"
  end
end
