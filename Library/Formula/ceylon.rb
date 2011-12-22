require 'formula'

class Ceylon < Formula
  url 'http://ceylon-lang.org/download/dist/1_0_Milestone1'
  homepage 'http://ceylon-lang.org/'
  md5 '627ebfc52fc9ba93fc63df59f8309509'
  version '1.0.M1'

  def install
    rm_f Dir["bin/*.bat"]

    doc.install Dir['doc/*']
    libexec.install Dir['*']

    bin.mkpath
    Dir["#{libexec}/bin/*"].each { |f| ln_s f, bin }
  end
end
