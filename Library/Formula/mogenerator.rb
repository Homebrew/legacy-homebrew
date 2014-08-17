require 'formula'

class Mogenerator < Formula
  homepage 'http://rentzsch.github.io/mogenerator/'
  url 'https://github.com/rentzsch/mogenerator/archive/1.27.tar.gz'
  sha1 'd9defaa6352624cacbe8640aa82af8e14de74848'

  head 'https://github.com/rentzsch/mogenerator.git'

  bottle do
    cellar :any
    sha1 "5c4f33afe033e7e921ecb9ba0361076eab5c5ea3" => :mavericks
    sha1 "bf0063bb5ebc46d39f977d3b1e51abe8bd96135b" => :mountain_lion
    sha1 "ca6653a594d61ecad7cae0955ac8299de88e0a79" => :lion
  end

  depends_on :xcode => :build

  def install
    xcodebuild "-target", "mogenerator", "-configuration", "Release","SYMROOT=symroot", "OBJROOT=objroot"
    bin.install "symroot/Release/mogenerator"
  end
end
