require 'formula'

class CracklibWords < Formula
  homepage 'http://cracklib.sourceforge.net'
  url 'https://downloads.sourceforge.net/project/cracklib/cracklib-words/2008-05-07/cracklib-words-20080507.gz'
  sha1 'e0cea03e505e709b15b8b950d56cb493166607da'

  bottle do
    cellar :any
    sha1 "372cd320ea6e9344917981da8b472494c0651ca9" => :yosemite
    sha1 "9062c71578a70c510c13ce5ec1c9b8f27365fda4" => :mavericks
    sha1 "d5adb62174571ba9e395b9143d9a1fcdfc3eb076" => :mountain_lion
  end

  depends_on 'cracklib'

  def install
    share.install "cracklib-words-#{version}" => "cracklib-words"
  end

  def post_install
    system "#{Formula["cracklib"].opt_bin}/cracklib-packer < #{share}/cracklib-words"
  end
end
