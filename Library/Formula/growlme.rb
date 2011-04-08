require 'formula'

class Growlme < Formula
  head 'git://github.com/robey/growlme.git'
  homepage 'https://github.com/robey/growlme'

  def install
    bin.install "growlme"
  end
end
