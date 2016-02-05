class Ltsa < Formula
  desc "LTS Analyser"
  homepage "http://www.doc.ic.ac.uk/~jnm/book/ltsa/LTSA_applet.html"
  url "http://www.doc.ic.ac.uk/~jnm/book/ltsa/ltsatool.zip"
  version "3.0"
  sha256 "9ed894c4f2ae22e119a4f48e6e3f36b38b08f8fe85a6ac85564f4c5045fe9046"

  depends_on :java => "2"

  def install
    prefix.install Dir["*"]
    system "echo '#!/bin/sh\\nnohup java -jar #{prefix}/ltsa.jar &\' > ltsa"
    bin.install "ltsa"
  end

  test do
    system "ltsa"
  end
end
