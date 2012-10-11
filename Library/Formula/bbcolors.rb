require 'formula'

class Bbcolors < Formula
  url 'http://daringfireball.net/projects/downloads/bbcolors_1.0.1.zip'
  homepage 'http://daringfireball.net/projects/bbcolors/'
  sha1 'ce47e5ffbcafb01c21acdf242372f351215a80bf'

  def install
    bin.install "bbcolors"
  end
end
