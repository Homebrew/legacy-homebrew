class Gotags < Formula
  desc "ctags-compatible tag generator for Go"
  homepage "https://github.com/jstemmer/gotags"
  url "https://github.com/jstemmer/gotags/archive/v1.3.0.tar.gz"
  sha256 "414e1f96b560b089f11f814cd9000974a8ee376bb2cd9119cce60368e89ba226"

  head "https://github.com/jstemmer/gotags.git"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    system "go", "build", "-o", "gotags"
    bin.install "gotags"
  end

  test do
    system "#{bin}/gotags", "-v"

    (testpath/"test.go").write <<-EOS.undent
      package main

      type Foo struct {
          Bar int
      }
    EOS

    require "open3"
    stdout_str, _ = Open3.capture2("#{bin}/gotags", (testpath/"test.go"))
    assert_match (/^Bar.*test.go.*$/) , stdout_str
    assert_match (/^Foo.*test.go.*$/) , stdout_str
  end
end
