require "formula"

class Gvp < Formula
  homepage "https://github.com/pote/gvp"
  url "https://github.com/pote/gvp/archive/v0.0.2.tar.gz"
  sha1 "28cbdea4c579ae4119bfd0fa451f03cb0572b43b"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert Kernel.system("gvp init"), "`gvp init` exited with a non-zero status"
    assert File.directory?(".godeps"), "`gvp init` did not create the .godeps directory"
    assert_equal `gvp in 'echo $GOPATH' | grep -v '>> Local GOPATH set.'`.chomp, "#{testpath/".godeps"}:#{testpath}", "`gvp in` did not change the GOPATH"
    assert_equal `gvp in 'echo $GOBIN' | grep -v '>> Local GOPATH set.'`.chomp, "#{testpath/".godeps/bin"}:#{ENV["GOBIN"]}", "`gvp in` did not change the GOBIN"
    assert_equal `gvp in 'echo $PATH' | grep -v '>> Local GOPATH set.'`.chomp, "#{testpath/".godeps/bin"}:#{ENV["PATH"]}", "`gvp in` did not change the PATH"
  end
end
