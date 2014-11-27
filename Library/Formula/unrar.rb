require 'formula'

class Unrar < Formula
  homepage 'http://www.rarlab.com'
  url 'http://www.rarlab.com/rar/unrarsrc-5.2.2.tar.gz'
  sha1 '5e30ab23aab82d2f8b747c5b6f7187e364eb360c'

  bottle do
    cellar :any
    sha1 "33e33999f8777632f6bfe858d47d7cca067eca24" => :yosemite
    sha1 "867a35827ffed8138962935311cb7bf330e63ec0" => :mavericks
    sha1 "127dd227504144b31a5513499ad72f6abe100953" => :mountain_lion
  end

  def install
    system "make"
    bin.install 'unrar'
  end

  test do
    contentpath = "directory/file.txt"
    rarpath = testpath/"archive.rar"
    data =  'UmFyIRoHAM+QcwAADQAAAAAAAACaCHQggDIACQAAAAkAAAADtPej1LZwZE' +
            'QUMBIApIEAAGRpcmVjdG9yeVxmaWxlLnR4dEhvbWVicmV3CsQ9ewBABwA='

    rarpath.write data.unpack('m').first
    assert_equal contentpath, `#{bin}/unrar lb #{rarpath}`.strip
    assert_equal 0, $?.exitstatus

    system "#{bin}/unrar", "x", rarpath, testpath
    assert_equal "Homebrew\n", (testpath/contentpath).read
  end
end
