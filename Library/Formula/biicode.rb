require "formula"

class Biicode < Formula
  homepage "http://www.biicode.com"
  url "https://s3.amazonaws.com/biibinaries/release/0.8/bii-macos64_0_8.pkg"
  sha1 "2aea27d118d03cb1106de0dba45f5d7384152c90"

  depends_on :xcode
  depends_on "cmake"

  def install
    system "sudo installer -pkg #{cached_download} -target /"
  end

  test do
    system "bii"
  end
end
