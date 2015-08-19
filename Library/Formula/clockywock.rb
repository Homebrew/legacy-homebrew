class Clockywock < Formula
  desc "Ncurses analog clock"
  homepage "http://soomka.com/"
  url "http://soomka.com/clockywock-0.3.1a.tar.gz"
  sha256 "278c01e0adf650b21878e593b84b3594b21b296d601ee0f73330126715a4cce4"

  def install
    system "make"
    bin.install "clockywock"
    man7.install "clockywock.7"
  end

  test do
    system "#{bin}/clockywock -h"
  end
end
