require "formula"

class Stan < Formula
  homepage "http://mc-stan.org"
  url "https://github.com/stan-dev/stan/archive/v2.2.0.tar.gz"
  sha1 "4c9be875f3627bb5e1089fd24600aa4fa4f862f3"

  depends_on :xcode
  
  keg_only "We don't want sym-links."
  
  def install
    system "make","bin/libstan.a"
    system "make", "-j2", "bin/stanc"
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
    system "make", "-j4", "O=0", "test-headers"
    system "make", "-j4", "O=0", "src/test/unit"
    system "make", "-j4", "O=0", "src/test/unit-agrad-rev"
    system "make", "-j4", "O=0", "src/test/unit-agrad-fwd"
    system "make", "-j4", "O=0", "src/test/unit-distribution"
    system "make", "-j4", "O=3", "src/test/CmdStan/models"
  end
end
