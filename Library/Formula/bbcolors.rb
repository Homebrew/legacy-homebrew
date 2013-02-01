require 'formula'

class Bbcolors < Formula
  homepage 'http://daringfireball.net/projects/bbcolors/'
  url 'http://daringfireball.net/projects/downloads/bbcolors_1.0.1.zip'
  sha1 'ce47e5ffbcafb01c21acdf242372f351215a80bf'

  def install
    bin.install "bbcolors"
  end
end
