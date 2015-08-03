class Swaks < Formula
  desc "SMTP command-line test tool"
  homepage "http://www.jetmore.org/john/code/swaks/"
  url "http://www.jetmore.org/john/code/swaks/files/swaks-20130209.0.tar.gz"
  sha256 "0b0967256dca82776f610f1db862bc47644b236f325fa48cbdb2651babd41f7c"

  def install
    bin.install "swaks"
  end
end
