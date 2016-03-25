class Gotags < Formula
  desc "ctags-compatible tag generator for Go"
  homepage "https://github.com/jstemmer/gotags"
  url "https://github.com/jstemmer/gotags/archive/v1.3.0.tar.gz"
  sha256 "414e1f96b560b089f11f814cd9000974a8ee376bb2cd9119cce60368e89ba226"

  head "https://github.com/jstemmer/gotags.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c3d45ab0288282b15e76d962064860c10fad509a68d58dcc339beee17f277609" => :el_capitan
    sha256 "72d7d85afb135baca77daaff911ae71cb87bd4b5a63df3e7c509e809745ea272" => :yosemite
    sha256 "c3d177bdf195516994e4179334d54897d74aef7e57b702d4e34224636b8a468e" => :mavericks
    sha256 "55a3ed971042138f7e985547e0f6074c42bbd16ffe23c1ab4604285a69f1ec28" => :mountain_lion
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    system "go", "build", "-o", "gotags"
    bin.install "gotags"
  end

  test do
    (testpath/"test.go").write <<-EOS.undent
      package main

      type Foo struct {
          Bar int
      }
    EOS

    assert_match (/^Bar.*test.go.*$/), shell_output("#{bin}/gotags #{testpath}/test.go")
  end
end
