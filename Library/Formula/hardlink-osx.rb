require "formula"

class HardlinkOsx < Formula
  homepage "https://github.com/jasonsyoung/hardlink-osx"
  url "https://github.com/jasonsyoung/hardlink-osx/archive/v0.3.tar.gz"
  sha1 "c6aa95c55cc424d7fe13c8a91b5db828c6ddc6a0"

  def install
    system "make"
    system "PREFIX=#{prefix} make install-homebrew"
  end

  def caveats; <<-EOS.undent
    Hardlinks can not be created under the same directory root. If you try to
    `hln source directory` to target directory under the same root you will get an error!

    Also, remember the binary is named `hln` due to a naming conflict.
    EOS
  end

  test do
    system "mkdir", "test1"
    system "mkdir", "test1/inner"
    system "mkdir", "test1/inner/file"
    system "mkdir", "second"
    system "#{bin}/hln", "test1", "otherdir/test2"

    system "test", "-d", "otherdir/test2"
    assert_equal 0, $?.exitstatus
    system "test", "-d", "otherdir/test2/inner"
    assert_equal 0, $?.exitstatus
    system "test", "-f", "otherdir/test2/inner/file"
    assert_equal 0, $?.exitstatus
  end
end
