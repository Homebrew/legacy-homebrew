require "language/go"

class Fugu < Formula
  desc "Docker command wrapper."
  homepage "https://github.com/mattes/fugu"
  url "https://github.com/mattes/fugu/archive/v1.1.1.tar.gz"
  sha256 "94ec61037c3afa1267ea990ffd03ba1d0d1628926b3fdde0133fece36fa81929"

  bottle do
    cellar :any_skip_relocation
    revision 2
    sha256 "51b5d051688093ffd7f44ab20599e01d236903d7c92f9d1765bd8ebce26a9dcb" => :el_capitan
    sha256 "76925e369d03b49158a9a55fe71d513b2f01c11c317ccc3ff3a166cd3790096c" => :yosemite
    sha256 "afaf8a3af2fa2cd5a7482fedd449abc9bd13a4d88d805c99c4f9b797a6329887" => :mavericks
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
