class Blink1 < Formula
  desc "Control blink(1) indicator light"
  homepage "https://blink1.thingm.com/"
  url "https://github.com/todbot/blink1/archive/v1.98.tar.gz"
  sha256 "2bbf8848c3c656ab8fb01035fd31103a321fbee20164691cf67e3706c4b50b16"
  head "https://github.com/todbot/blink1.git"

  bottle do
    cellar :any
    sha256 "2e9f712db6e0443831f0a11388eaa39d427436dba52fae83761090d13140c47f" => :yosemite
    sha256 "354dfc245bab10e35bc8c62e8d44fe883b7b8dff43c7962655b88571f044f448" => :mavericks
    sha256 "214dd7f114200d9425bfa51bf52b7c46f48f4bd4668e193aaf3fb5a8fcfdb94d" => :mountain_lion
  end

  def install
    cd "commandline" do
      system "make"
      bin.install "blink1-tool"
      lib.install "libBlink1.dylib"
      include.install "blink1-lib.h"
    end
  end

  test do
    system bin/"blink1-tool", "--version"
  end
end
