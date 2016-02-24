class Blink1 < Formula
  desc "Control blink(1) indicator light"
  homepage "https://blink1.thingm.com/"
  url "https://github.com/todbot/blink1/archive/v1.98.tar.gz"
  sha256 "2bbf8848c3c656ab8fb01035fd31103a321fbee20164691cf67e3706c4b50b16"
  head "https://github.com/todbot/blink1.git"

  bottle do
    cellar :any
    sha256 "227e1fce1bcd3f50cb39231e8ec0e0638b068f68433a12c8a3bac8adfa90961c" => :el_capitan
    sha256 "1536128c6ba6957f3d5f287ab4e0fcc28053ca54604f0ffae06eef2f96c4da88" => :yosemite
    sha256 "1bba2becfb93f831b91654400827acad41de00c2fcfe45b5ca14336fa3545cfd" => :mavericks
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
