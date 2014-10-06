require "formula"

class Gvp < Formula
  homepage "https://github.com/pote/gvp"
  url "https://github.com/pote/gvp/archive/v0.1.0.tar.gz"
  sha1 "c48bae47f8589e9bfd8addc94a9073be4c004305"

  bottle do
    cellar :any
    sha1 "06092cbaeda1a2e565868dd27eb8d71ce62d0477" => :mavericks
    sha1 "79eadbc9c59afd18e6406773892269519ecbfc6e" => :mountain_lion
    sha1 "ae36dae26ce09281e6bf173f53eca9a7da56d97b" => :lion
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
