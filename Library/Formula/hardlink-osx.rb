require "formula"

class HardlinkOsx < Formula
  homepage "https://github.com/selkhateeb/hardlink"
  url "https://github.com/selkhateeb/hardlink/archive/v0.1.tar.gz"
  sha1 "b9f043d9f5384d54b65cf3617ebf101a2121c94f"

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
    system "mkdir", "-p", "test1/inner"
    system "touch", "test1/inner/file"
    system "mkdir", "otherdir"
    system "#{bin}/hln", "test1", "otherdir/test2"

    system "test", "-d", "otherdir/test2"
    assert_equal 0, $?.exitstatus
    system "test", "-d", "otherdir/test2/inner"
    assert_equal 0, $?.exitstatus
    system "test", "-f", "otherdir/test2/inner/file"
    assert_equal 0, $?.exitstatus
  end
end