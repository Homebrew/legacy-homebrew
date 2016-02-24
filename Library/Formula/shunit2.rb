class Shunit2 < Formula
  desc "xUnit unit testing framework for Bourne-based shell scripts"
  homepage "https://code.google.com/p/shunit2/"
  url "https://shunit2.googlecode.com/files/shunit2-2.1.6.tgz"
  sha256 "65a313a76fd5cc1c58c9e19fbc80fc0e418a4cbfbd46d54b35ed5b6e0025d4ee"

  bottle :unneeded

  def install
    bin.install "src/shunit2"
  end

  test do
    system "#{bin}/shunit2"
  end
end
