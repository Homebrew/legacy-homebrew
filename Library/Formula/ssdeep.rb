require "formula"

class Ssdeep < Formula
  homepage "http://ssdeep.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ssdeep/ssdeep-2.12/ssdeep-2.12.tar.gz"
  sha256 "89049e87adfd16b51bd8601d01cf02251df7513c4e0eb12576541bcb2e1e4bde"

  bottle do
    cellar :any
    sha1 "65ea78b9b08334ce62b419672bdc4bdc40975dca" => :yosemite
    sha1 "03f7b4328bf9140f699fe5dfbf3afdb2ca0a3196" => :mavericks
    sha1 "7defdbf5042a2db364067a6f7f79ca4f0115d5a0" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
