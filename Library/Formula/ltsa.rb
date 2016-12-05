class Ltsa < Formula
  desc "LTS Analyser"
  homepage "http://www.doc.ic.ac.uk/ltsa"
  url "http://www.doc.ic.ac.uk/~jnm/book/ltsa/ltsa.jar"
  version "3.0"
  sha256 "2068bfd818f2ea3558ceb78f33ec127a8fc0869c944ee98eacf1ab6d762347de"
  depends_on :java => "2"

  def install
    prefix.install "ltsa.jar"
    system "echo '#!/bin/sh\\nnohup java -jar #{prefix}/ltsa.jar &\' > ltsa"
    bin.install "ltsa"
  end

  test do
    system "ltsa"
  end
end
