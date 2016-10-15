require "formula"

class Jsoncpp < Formula
  homepage "http://jsoncpp.sourceforge.net"
  url "https://downloads.sourceforge.net/project/jsoncpp/jsoncpp/0.5.0/jsoncpp-src-0.5.0.tar.gz"
  sha1 "7169a50c7615070b6190076a7b5e86c45b7440b7"

  depends_on "scons" => :build

  def install
    scons "platform=linux-gcc"
  end

  test do
    scons "platform=linux-gcc check"
  end
end
