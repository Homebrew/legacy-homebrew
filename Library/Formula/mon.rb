class Mon < Formula
  desc "Monitor hosts/services/whatever and alert about problems"
  homepage "https://github.com/visionmedia/mon"
  url "https://github.com/visionmedia/mon/archive/1.2.3.tar.gz"
  sha256 "978711a1d37ede3fc5a05c778a2365ee234b196a44b6c0c69078a6c459e686ac"

  bottle do
    cellar :any
    sha256 "a3305413b9c09f2bce3a9c1b8204e05b673fe0d2dade6e5f0f9746eb67662f9e" => :mavericks
    sha256 "8c31501863d20c6b582f577055bc55b40743725911c7015a38d93991eeb71ed8" => :mountain_lion
    sha256 "36e66fd7d8452b14e15f5110ae0689c4e6ae9aa5a3977d4941df37aa71c96a23" => :lion
  end

  def install
    bin.mkpath
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"mon", "-V"
  end
end
