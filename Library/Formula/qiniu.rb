require "formula"
## qiniu dev tool 

class Qiniu < Formula
  homepage "http://developer.qiniu.com/docs/v6/tools/qboxrsctl.html"
  url "http://devtools.qiniu.io/qiniu-devtools-darwin_amd64-v2.7.20140630.tar.gz"
  sha1 "fe91d20d768b6a91453581ab104c175b21e40ecb"
  version "2.7.20140630"
  def install
     bin.install "qboxrsctl", "qetag","qrsboxcli","qrsync"
  end
end
