require "language/go"

class Fugu < Formula
  desc "Docker command wrapper."
  homepage "https://github.com/mattes/fugu"
  url "https://github.com/mattes/fugu/archive/v1.1.1.tar.gz"
  sha256 "94ec61037c3afa1267ea990ffd03ba1d0d1628926b3fdde0133fece36fa81929"

  bottle do
    cellar :any
    sha256 "ea7fc32f2683bd6902bdddb3bcd9a51bf40fce495e3aeb5d52e493d57a928c9b" => :yosemite
    sha256 "7f0774ebb3abec005f5c0e44cb3a2e574d3382ee33bf43ae6b4981e1ab80907a" => :mavericks
    sha256 "547f6aa26659e6f13a2dd0b83b1d95e375f905d52a5447bf797a4395386e37c0" => :mountain_lion
  end

  depends_on "go" => :build
  depends_on "docker" => :recommended

  go_resource "github.com/tools/godep" do
    url "https://github.com/tools/godep.git", :revision => "e2d1eb1649515318386cc637d8996ab37d6baa5e"
  end

  go_resource "github.com/kr/fs" do
    url "https://github.com/kr/fs.git", :revision => "2788f0dbd16903de03cb8186e5c7d97b69ad387b"
  end

  def install
    mkdir_p buildpath/"src/github.com/mattes/"
    ln_s buildpath, buildpath/"src/github.com/mattes/fugu"

    ENV["GOPATH"] = buildpath
    Language::Go.stage_deps resources, buildpath/"src"

    cd buildpath/"src/github.com/tools/godep" do
      system "go", "install"
    end

    cd buildpath/"fugu" do
      system buildpath/"bin/godep", "go", "build", "-o", bin/"fugu", "main.go", "usage.go", "version.go"
    end
  end

  test do
    (testpath/"fugu.yml").write <<-EOS.undent
      label1:
        image: ubuntu
        name: my-ubuntu
      label2:
        name: another-ubuntu
    EOS
    assert_match /label2/, shell_output("#{bin}/fugu show-labels --source file://#{testpath}/fugu.yml")
  end
end
