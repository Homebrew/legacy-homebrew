require "formula"

class P4 < Formula
  homepage "http://www.perforce.com"
  version "2014.1"
  
  if MacOS.prefer_64_bit?
    url "http://cdist2.perforce.com/perforce/r14.1/bin.macosx105x86_64/p4"
    sha1 "9a7e43b887066a087da71c238bcd78a00b065e6a"
  else
    url "http://cdist2.perforce.com/perforce/r14.1/bin.macosx105x86/p4"
    sha1 "990d7ced3ca2b16cb6aeeb4d6083f11c260857af"
  end

  def install
    bin.install "p4"
  end
end
