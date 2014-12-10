require 'formula'

class Watch < Formula
  homepage 'http://www.sveinbjorn.org'
  url 'http://www.sveinbjorn.org/files/software/watch-0.3-macosx.zip'

  version '0.3.0'
  sha1 '8c11b9fabd0adda4f3717f1a1e2bc01b54bcbd6c'

  conflicts_with 'visionmedia-watch'

  def install
    cd "watch-0.3-macosx" do
      system "rm", "watch"
      system "make", "watch"
      bin.install "watch"
      man1.install "watch.1"
    end
  end
end
