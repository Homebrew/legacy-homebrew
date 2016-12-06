require "language/go"

class Droot < Formula
  homepage "https://github.com/yuuki1/droot"
  url "https://github.com/yuuki1/droot.git", :tag => "v0.2.0", :revision => "8e7dd1440f06ab1a1cc7205ab0d04bf406c15677"

  head "https://github.com/yuuki1/droot.git", :branch => "master"

  depends_on "go" => :build
  depends_on :hg => :build

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/yuuki1/"
    ln_sf buildpath, buildpath/"src/github.com/yuuki1/droot/"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", "droot"
    bin.install "droot"

  end

  test do
    (testpath/"test.go").write <<-EOS.undent
      package main

      type Foo struct {
          Bar int
      }
    EOS
    assert_match (/^Bar.*test.go.*$/), shell_output("#{bin}/droot #{testpath}/test.go")
  end
end
