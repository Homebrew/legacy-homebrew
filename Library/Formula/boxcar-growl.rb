require "formula"

class BoxcarGrowl < Formula
  homepage "https://github.com/sharl/boxcar-growl"
  url "https://github.com/sharl/boxcar-growl/archive/Boxcar2.tar.gz"
  sha1 "82f988bb908f24975f24d7ae204c1639812c462e"

  def install
    bin.install "boxcar-growl"
  end

  def caveats
    msg = <<-EOS.undent
      For boxcar-growl to work, you will need to provide your Boxcar credentials.
      The easiest way to do this is to put the following in ~/.boxcar-growl:
         token = xxxxxxxxxxxxxxxxxx
      (replace xxxxxxxxxxxxxxxxxx with your Boxcar access token)
    EOS
  end
end
