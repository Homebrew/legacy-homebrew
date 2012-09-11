require 'formula'

class Kindlegen < Formula
  homepage 'http://www.amazon.com/gp/feature.html?ie=UTF8&docId=1000765211'
  url 'http://s3.amazonaws.com/kindlegen/KindleGen_Mac_i386_v2_5.zip'
  version '2.5'
  sha1 'fcf48303606d9d532c5649ccbed3d70e40a9f4a4'

  def install
    bin.install 'kindlegen'
  end

  def test
    system "kindlegen"
  end
end
