require 'formula'

class Unrar < Formula
  homepage 'http://www.rarlab.com'
  url 'http://www.rarlab.com/rar/unrarsrc-5.2.3.tar.gz'
  sha1 '31e7dad7424635e7a3ae823b5dd9e50db54393ec'

  bottle do
    cellar :any
    sha1 "5c3d060feb9868d4202b1bff08629029d35a4750" => :yosemite
    sha1 "3ce2295bc0a90243b0c71219c53e95685d79d1ca" => :mavericks
    sha1 "8e0e4373750950fde98da68cf3ee247ddfb02558" => :mountain_lion
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
