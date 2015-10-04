class Runcocoa < Formula
  desc "Tools to run Cocoa/Objective-C and C code from the command-line"
  homepage "https://github.com/michaeltyson/Commandline-Cocoa"
  url "https://github.com/michaeltyson/Commandline-Cocoa/archive/834f73b4b5d0d2be0d336c9869973f5f0db55949.tar.gz"
  sha256 "d90079efb92c8eef3c8e2c142683eb0c632ca61120c9e4a617bf9dac5362bf86"
  version "20120108"

  def install
    bin.install "runcocoa.sh" => "runcocoa"
    bin.install "runc.sh" => "runc"
  end
end
