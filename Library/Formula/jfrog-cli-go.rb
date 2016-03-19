class JfrogCliGo < Formula
  desc "command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/JFrogDev/jfrog-cli-go"
  url "https://github.com/JFrogDev/jfrog-cli-go/archive/1.0.1.tar.gz"
  sha256 "9189993c3201dc354a73fdbd5dfdecb8ae077ef06e2d3badc6ac6450e7c64eaa"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "go", "get", "github.com/jfrogdev/jfrog-cli-go/..."
    system "go", "build", "-o", "#{bin}/jfrog", "github.com/jfrogdev/jfrog-cli-go/jfrog"
  end

  test do
    actual = pipe_output("#{bin}/jfrog rt -v")
    expected = "jfrog version 1.0.1\n"
    assert_equal expected, actual
  end
end
