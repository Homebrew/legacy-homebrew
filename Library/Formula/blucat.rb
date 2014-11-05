require "formula"

class Blucat < Formula
  homepage "http://blucat.sourceforge.net/blucat/"
  url "http://blucat.sourceforge.net/blucat/wp-content/uploads/2013/10/blucat-aa3e02.zip"
  sha1 "c5c801700b5d4d59f6bf0a5f0e4a405237de1840"

  depends_on "ant" => :build

  def install
    system "ant"
    libexec.install "blucat"
    libexec.install "lib"
    libexec.install "build"
    
    ## Now make a launcher script. This is required because launching
    ## the default blucat script uses the script path to find the
    ## library files. This allows a user to include the repo in their
    ## PATH and changing it would be complicated I think. This allows
    ## the code to change independent of this brew installer.
    system "echo \"#!/bin/bash\" > blucat"
    system "echo " << libexec << "/blucat >> blucat"
    system "chmod +x blucat"
    bin.install "blucat"
  end

  test do
    system "true"
  end
end
