require 'formula'

class Subl < Formula
  homepage 'http://sublimetext.com'
  url 'https://github.com/metamorfos/subl/tarball/master'
  sha1 '1d6a8196f28284df3fdc4cdfe97468c9f8da0e88'
  version '2.0'
  
  def install
    bin.install "subl"
  end
end
