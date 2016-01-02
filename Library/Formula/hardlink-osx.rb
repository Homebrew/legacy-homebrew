class HardlinkOsx < Formula
  desc "Command-line utility that implements hardlinks on OS X"
  homepage "https://github.com/selkhateeb/hardlink"
  url "https://github.com/selkhateeb/hardlink/archive/v0.1.1.tar.gz"
  sha256 "5876554e6dafb6627a94670ac33e750a7efeb3a5fbde5ede3e145cdb5131d1ba"

  bottle do
    cellar :any_skip_relocation
    sha256 "edf85db2b0586c410dd96f8ab50cf4cc0f34d1494b3b91a5ef0b00ae16fed3c0" => :el_capitan
    sha256 "dcba3e0320ca63d1b958173aa9e2ac24074c5c1f94becaba07f0c92e721b941e" => :yosemite
    sha256 "2ebdf76a67f7c63614d581963d92d79de15cf834b7e3857c139f474db71aab73" => :mavericks
    sha256 "fb90d16f641a705e9101133d44a3274db764eca6350bfcc453447cac4bb3cfaf" => :mountain_lion
  end

  def install
    system "make"
    bin.mkdir
    system "make", "install", "PREFIX=#{prefix}"
  end

  def caveats; <<-EOS.undent
    Hardlinks can not be created under the same directory root. If you try to
    `hln source directory` to target directory under the same root you will get an error!

    Also, remember the binary is named `hln` due to a naming conflict.
    EOS
  end

  test do
    mkdir_p "test1/inner"
    touch "test1/inner/file"
    mkdir "otherdir"
    system "#{bin}/hln", "test1", "otherdir/test2"
    assert File.directory? "otherdir/test2"
    assert File.directory? "otherdir/test2/inner"
    assert File.file? "otherdir/test2/inner/file"
  end
end
