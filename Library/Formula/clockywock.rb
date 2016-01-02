class Clockywock < Formula
  desc "Ncurses analog clock"
  homepage "http://soomka.com/"
  url "http://soomka.com/clockywock-0.3.1a.tar.gz"
  sha256 "278c01e0adf650b21878e593b84b3594b21b296d601ee0f73330126715a4cce4"

  bottle do
    cellar :any_skip_relocation
    sha256 "12ce1b232f8dfa658e774f8ae08b99f40ca6ae12ee2d5df41af67412412c2b43" => :el_capitan
    sha256 "fccbf3e83841993156fa544c0b0f30a92058facf07ce5b1e622aec78e2573aff" => :yosemite
    sha256 "c4919f759cc8446bc8d83ff71a52de61bd8ba8db11eccfb43270e54c1949227f" => :mavericks
  end

  def install
    system "make"
    bin.install "clockywock"
    man7.install "clockywock.7"
  end

  test do
    system "#{bin}/clockywock", "-h"
  end
end
