class Timedog < Formula
  desc "Lists files that were saved by a backup of the OS X Time Machine"
  homepage "http://timedog.googlecode.com/"
  url "https://timedog.googlecode.com/files/timedog-1.3.zip"
  sha256 "4683f37a28407dabc5c56dc45e6480dd2db460289321edce8980a236cc2787ec"

  bottle :unneeded

  def install
    bin.install "timedog"
  end
end
