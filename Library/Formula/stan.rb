require "formula"

class Stan < Formula
  homepage "http://mc-stan.org"
  url "https://github.com/stan-dev/stan/archive/v2.2.0.tar.gz"
  sha1 "4c9be875f3627bb5e1089fd24600aa4fa4f862f3"
  depends_on :xcode
  keg_only "We don't want sym-links."

  def install
    ENV['HOMEBREW_OPTIMIZATION_LEVEL'] ='O3'
    system "make", "bin/libstan.a"
    ENV['HOMEBREW_OPTIMIZATION_LEVEL'] ='O0'
    system "make", "bin/stanc"
    ENV['HOMEBREW_OPTIMIZATION_LEVEL'] ='O3'
    system "make", "bin/print"
    (var/"stan-home").install "makefile"
    (var/"stan-home/bin").install Dir["bin/*"]
    (var/"stan-home/make").install Dir["make/*"]
    (var/"stan-home/src").install Dir["src/*"]
    (var/"stan-home/lib").install Dir["lib/*"]
    doc.install Dir["doc/*"]
  end

  test do
    cd "#{HOMEBREW_PREFIX}/var/stan-home/"
    ENV['HOMEBREW_OPTIMIZATION_LEVEL'] ='O0'
    system "make", "test-headers"
    system "make", "src/test/unit"
    system "make", "src/test/unit-agrad-rev"
    system "make", "src/test/unit-agrad-fwd"
    system "make", "src/test/unit-distribution"
    ENV['HOMEBREW_OPTIMIZATION_LEVEL'] ='O3'
    system "make", "src/test/CmdStan/models"
  end
end
