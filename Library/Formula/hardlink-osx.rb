class HardlinkOsx < Formula
  desc "Command-line utility that implements hardlinks on OS X"
  homepage "https://github.com/selkhateeb/hardlink"
  url "https://github.com/selkhateeb/hardlink/archive/v0.1.1.tar.gz"
  sha256 "5876554e6dafb6627a94670ac33e750a7efeb3a5fbde5ede3e145cdb5131d1ba"

  bottle do
    cellar :any
    sha1 "b8e5b31796d36c818c302bddbd45f227dc943a13" => :yosemite
    sha1 "d61a54cff4e7ff52a0fc3131188d6adecf5ad35a" => :mavericks
    sha1 "15910f042ea3aac09d8a2e94c783ec30e47e1f3a" => :mountain_lion
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
