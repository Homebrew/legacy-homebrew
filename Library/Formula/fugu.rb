require "language/go"

class Fugu < Formula
  desc "Docker command wrapper."
  homepage "https://github.com/mattes/fugu"
  url "https://github.com/mattes/fugu/archive/v1.1.1.tar.gz"
  sha256 "94ec61037c3afa1267ea990ffd03ba1d0d1628926b3fdde0133fece36fa81929"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "319b2c0dbb6a216501fa4bd22deb7981fcb66cc43c05887c617f76466ccabc77" => :el_capitan
    sha256 "7eb31174fe5f1ed36f3026e5002d610468b38b1a968ae7fe58edb77439b6bc9b" => :yosemite
    sha256 "0ff5162567bcba3ab4673942708b3c6de207b2e01aec45faed761f8832942817" => :mavericks
  end

  depends_on "go" => :build
  depends_on "godep" => :build
  depends_on "docker" => :recommended

  go_resource "github.com/kr/fs" do
    url "https://github.com/kr/fs.git", :revision => "2788f0dbd16903de03cb8186e5c7d97b69ad387b"
  end

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO15VENDOREXPERIMENT"] = "0"
    mkdir_p buildpath/"src/github.com/mattes/"
    ln_s buildpath, buildpath/"src/github.com/mattes/fugu"
    Language::Go.stage_deps resources, buildpath/"src"

    cd buildpath/"fugu" do
      system "godep", "go", "build", "-o", bin/"fugu", "main.go", "usage.go", "version.go"
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
