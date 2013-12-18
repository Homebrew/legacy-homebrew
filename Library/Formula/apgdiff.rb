require 'formula'

class Apgdiff < Formula
  homepage 'http://www.apgdiff.com/'
  url 'http://www.apgdiff.com/download/apgdiff-2.4-bin.zip'
  sha1 '1150d44e9da2c1417767d4106bdb297ed0adfed8'

  def install
    libexec.install "apgdiff-#{version}.jar"
    bin.write_jar_script libexec/"apgdiff-#{version}.jar", "apgdiff"
  end
end
