require 'formula'

class Unrar < Formula
  homepage 'http://www.rarlab.com'
  url 'http://www.rarlab.com/rar/unrarsrc-5.2.6.tar.gz'
  sha1 'bdd4c8936fd0deb460afe8b7afa9322dd63f3ecb'

  bottle do
    cellar :any
    sha1 "5c3d060feb9868d4202b1bff08629029d35a4750" => :yosemite
    sha1 "3ce2295bc0a90243b0c71219c53e95685d79d1ca" => :mavericks
    sha1 "8e0e4373750950fde98da68cf3ee247ddfb02558" => :mountain_lion
  end

  def install
    system "make"
    # Explicitly clean up for the library build to avoid an issue with an apparent
    # implicit clean which confuses the dependencies.
    system "make", "clean"
    system "make", "lib"

    bin.install 'unrar'
    # NOTE: Sent an email to dev@rarlab.com (18-Feb-2015) asking them to look into the
    #       need for the explicit clean, and to change the make to generate a dylib file
    #       on OS X
    lib.install "libunrar.so" => "libunrar.dylib"

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
