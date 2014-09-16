require "formula"

class Dued < Formula
  homepage "https://github.com/unforswearing/dued"
  url "https://github.com/unforswearing/dued/blob/master/dued.rb.zip"
  sha1 "4109335a65cc2deb712c2cf526ff2dd93ef20db6"
  version "0.1"

 def install
bin.install 'bin/dued'
end
test do
system "#{bin}/dued"
end
end



