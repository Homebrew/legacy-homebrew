require "formula"

class Blucat < Formula
  homepage "http://blucat.sourceforge.net/blucat/"
  url "http://blucat.sourceforge.net/blucat/wp-content/uploads/2013/10/blucat-aa3e02.zip"
  sha1 "c5c801700b5d4d59f6bf0a5f0e4a405237de1840"

  depends_on "ant"

  def install
    system "ant"
    prefix.install "blucat"
    prefix.install Dir["lib"]
    prefix.install Dir["build"]
    
    ## now make a launcher script 
    system "echo \"#!/bin/bash\" > blucat"
    system "echo " << prefix << "/blucat >> blucat"
    system "chmod +x blucat"
    bin.install "blucat"
  end

  test do
    system "true"
  end
end
