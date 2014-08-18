require "formula"
class Readedid < Formula
   homepage "https://github.com/othercat/readEDID"
   stable do
    url "https://github.com/othercat/readEDID", :using => :git, :tag => "1.0.1"
   end
   devel do
    url 'https://github.com/othercat/readEDID.git', :branch => 'master'
    version "1.0.1"
   end
   depends_on "cmake" => :build
   depends_on :macos => :snow_leopard
   def install
    system "cmake", "-G","Xcode", "./readEDID/"
    xcodebuild "-target readedid SYMROOT=build CONFIGURATION_BUILD_DIR=bin"
    system "mkdir","/Users/lirichard/Developer/SourceCodes/github/homebrew/Cellar/readedid/1.0.1/bin/"
    system "cp","bin/Debug/readedid","/Users/lirichard/Developer/SourceCodes/github/homebrew/Cellar/readedid/1.0.1/bin/"
    #system "cp","doc/readedid.1","/Users/lirichard/Developer/SourceCodes/github/homebrew/share/man/man1/"
   end
   test do
    #system "false"
   end
end
