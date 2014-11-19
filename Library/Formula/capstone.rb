require 'formula'

class Capstone < Formula
  homepage 'http://capstone-engine.org'
  url 'http://capstone-engine.org/download/3.0/capstone-3.0.tgz'
  sha1 '26e591b8323ed3f6e92637d7ee953cb505687efa'

  bottle do
    cellar :any
    sha1 "a8cfc17c27c20595ed62158f262091953a482ddb" => :yosemite
    sha1 "64c79e1492ec327332875846d3f5660ab82b7796" => :mavericks
    sha1 "811f7603c5d1ba0fd09c943215442c4041fd3593" => :mountain_lion
  end

  def install
    ENV["PREFIX"] = prefix
    ENV["HOMEBREW_CAPSTONE"] = "1"
    system "./make.sh"
    system "./make.sh", "install"
  end
end
