class StanfordParser < Formula
  desc "Statistical NLP parser"
  homepage "http://nlp.stanford.edu/software/lex-parser.shtml"
  url "http://nlp.stanford.edu/software/stanford-parser-full-2015-04-20.zip"
  version "3.5.2"
  sha256 "05bd11e500219bbbffa4bae004619560bc03f1481f9516c4bb51863e265333b8"

  bottle :unneeded

  def install
    libexec.install Dir["*"]
    bin.write_exec_script Dir["#{libexec}/*.sh"]
  end

  test do
    system "#{bin}/lexparser.sh", "#{libexec}/data/testsent.txt"
  end
end
