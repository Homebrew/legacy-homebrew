class Pjscrape < Formula
  homepage "https://nrabinowitz.github.io/pjscrape/"
  url "https://github.com/nrabinowitz/pjscrape/archive/v0.1.4.tar.gz"
  sha256 "a605781448486dfaeeceba1fdf5884170ebe385c776d7c5719b2f559d6a74ba6"

  head "https://github.com/nrabinowitz/pjscrape.git"

  depends_on "phantomjs"

  def install
    libexec.install Dir["*"]

    (bin/"pjscrape").write <<-EOS.undent
      #!/bin/bash
      "#{Formula["phantomjs"].opt_bin}/phantomjs" "#{libexec}/pjscrape.js" $*
    EOS
    chmod 0755, bin/"pjscrape"
  end
end
