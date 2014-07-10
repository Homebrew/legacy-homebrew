require "formula"

class Gvp < Formula
  homepage "https://github.com/pote/gvp"
  url "https://github.com/pote/gvp/archive/0.0.4.tar.gz"
  sha1 "39676c4dd1df4d099cf938122733fb5e2e24c0a0"

  bottle do
    cellar :any
    sha1 "90298a9ed2cf413b50ce0c6f6161e07ab599c7b8" => :mavericks
    sha1 "67d85bfdd6870d5f585ada006932ca84ec3923af" => :mountain_lion
    sha1 "4cecc33e461869ac88caedc4351ba785022b25d5" => :lion
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert Kernel.system("#{bin}/gvp init"), "`gvp init` exited with a non-zero status"
    assert File.directory?(".godeps"), "`gvp init` did not create the .godeps directory"
    assert_equal `#{bin}/gvp in 'echo $GOPATH' | grep -v '>> Local GOPATH set.'`.chomp, "#{testpath}/.godeps:#{testpath}", "`gvp in` did not change the GOPATH"
    assert_equal `#{bin}/gvp in 'echo $GOBIN' | grep -v '>> Local GOPATH set.'`.chomp, "#{testpath}/.godeps/bin", "`gvp in` did not change the GOBIN"
    assert_equal `#{bin}/gvp in 'echo $PATH' | grep -v '>> Local GOPATH set.'`.chomp, "#{testpath}/.godeps/bin:#{ENV["PATH"]}", "`gvp in` did not change the PATH"
  end
end
