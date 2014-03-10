require "formula"

class Utfcpp < Formula
  homepage "http://utfcpp.sourceforge.net/"
  url "http://downloads.sourceforge.net/project/utfcpp/utf8cpp_2x/Release%202.3.4/utf8_v2_3_4.zip"
  sha1 "638910adb69e4336f5a69c338abeeea88e9211ca"

  def install
    doc.install Dir['doc/*']
    include.install Dir['source/*']
  end
end
