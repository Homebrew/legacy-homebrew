require 'formula'

class Analog < Formula
  homepage 'http://analog.cx'
  url 'http://analog.cx/analog-6.0.tar.gz'
  sha1 '17ad601f84e73c940883fb9b9e805879aac37493'

  depends_on 'gd'
  depends_on 'jpeg'
  depends_on 'libpng'

  def install
    system "make DEFS='-DLANGDIR=\\\"#{share}/lang/\\\"'"

    bin.install "analog", "analog.cfg"
    share.install "examples", "how-to", "images", "lang"
    man1.install "analog.man" => "analog.1"
  end

  def test
    system "#{bin}/analog > /dev/null"
  end
end
