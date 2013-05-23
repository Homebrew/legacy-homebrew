require 'formula'

class Mplayershell < Formula
  homepage 'https://github.com/donmelton/MPlayerShell'
  url 'https://github.com/donmelton/MPlayerShell/archive/0.9.0.tar.gz'
  sha1 '0ed15622abd020b1924aaead7f3e373f36c98a47'

  head 'https://github.com/donmelton/MPlayerShell.git', :using => :git

  option 'with-mplayer2', 'Depend on mplayer2 package instead of mplayer'

  if build.include? 'with-mplayer2' then
    depends_on 'mplayer2' => :build
  else
    depends_on 'mplayer' => :build
  end

  depends_on :xcode

  def install
    system "xcodebuild", 'SYMROOT=build'
    bin.install 'build/Release/mps'
    man1.install 'Source/mps.1'
  end

  test do
    system "mps"
  end
end
