class Flvstreamer < Formula
  desc "Stream audio and video from flash & RTMP Servers"
  homepage "http://www.nongnu.org/flvstreamer/"
  url "http://download.savannah.gnu.org/releases-noredirect/flvstreamer/source/flvstreamer-2.1c1.tar.gz"
  sha256 "e90e24e13a48c57b1be01e41c9a7ec41f59953cdb862b50cf3e667429394d1ee"

  bottle do
    cellar :any
    sha256 "c482f23b62201380a31020f313090e9c31503857bbf5c4aa29ee3b8841bfaa06" => :yosemite
    sha256 "0b2cbacc0699791328dc9a8c6d2b2755b467b01495432889eaf2e2ab4f589a11" => :mavericks
    sha256 "cc023cb31d4813460d8acb63cfd8f23dfe881b4d4b5bd5d7c84d4aae15369c28" => :mountain_lion
  end

  def install
    system "make", "posix"
    bin.install "flvstreamer", "rtmpsrv", "rtmpsuck", "streams"
  end

  test do
    system "#{bin}/flvstreamer", "-h"
  end
end
