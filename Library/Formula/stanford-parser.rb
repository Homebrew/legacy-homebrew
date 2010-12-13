require 'formula'

class StanfordParser <Formula
  url 'http://nlp.stanford.edu/software/stanford-parser-2010-02-26.tgz'
  homepage 'http://nlp.stanford.edu/software/lex-parser.shtml'
  md5 '25e26c79d221685956d2442592321027'
  version '1.6.2'

  def shim_script target_script
    <<-EOS
#!/bin/bash
exec "#{libexec}/#{target_script}" $@
EOS
  end

  def install
    libexec.install Dir['*']
    Dir["#{libexec}/*.csh"].each do |f|
      f = File.basename(f)
      (bin+f).write shim_script(f)
    end
  end

  def test
    system "lexparser.csh", "#{libexec}/testsent.txt"
  end
end
