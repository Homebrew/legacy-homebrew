require 'formula'

class Bonnie < Formula
  homepage 'http://code.google.com/p/bonnie-64/'
  head 'http://bonnie-64.googlecode.com/svn/trunk/'

  def install
    system "make"
    bin.install "Bonnie" => "bonnie"
  end
end
