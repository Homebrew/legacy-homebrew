require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Denominator < Formula
  homepage 'https://github.com/Netflix/denominator'
  url 'http://dl.bintray.com/content/netflixoss/denominator/denominator?direct', :using  => :nounzip
  sha1 '6a82c22c68a8b14d6bbc5be74ad43ae95a050b25'
  version '1.0'

  def install
    mv "denominator?direct", "denominator"
    bin.install Dir['*']
    system "chmod 755 #{prefix}/bin/denominator"
  end

end
