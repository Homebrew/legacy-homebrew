require "language/go"

class Fugu < Formula
  desc "Docker command wrapper."
  homepage "https://github.com/mattes/fugu"
  url "https://github.com/mattes/fugu/archive/v1.1.1.tar.gz"
  sha256 "94ec61037c3afa1267ea990ffd03ba1d0d1628926b3fdde0133fece36fa81929"

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
