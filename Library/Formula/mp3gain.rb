require 'formula'

class Mp3gain < Formula
  homepage 'http://mp3gain.sourceforge.net'
  url 'https://downloads.sourceforge.net/project/mp3gain/mp3gain/1.5.2/mp3gain-1_5_2_r2-src.zip'
  version '1.5.2'
  sha1 'cc7de597861803ac55199b8093c84f86fb5807f1'

  def install
    system "make"
    bin.install 'mp3gain'
  end
end

