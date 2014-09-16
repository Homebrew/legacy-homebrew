require "formula"

class Dued < Formula
  homepage "https://github.com/unforswearing/dued"
  url "https://github.com/unforswearing/dued/blob/master/dued.rb.zip"
  sha1 "348a0ba1a632bcc9a4ccf10b173cbdde46618ca0"
  version "0.1"

 def install
bin.install 'bin/dued'
end
test do
system "#{bin}/dued"
end
end



