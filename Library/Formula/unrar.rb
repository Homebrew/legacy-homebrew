require 'formula'

class Unrar < Formula
  homepage 'http://www.rarlab.com'
  url 'http://www.rarlab.com/rar/unrarsrc-5.1.6.tar.gz'
  sha1 'af9220d85cb96ce102b7375c1e5e501b64fc89fd'

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
