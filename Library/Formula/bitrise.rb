require "language/go"

class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.2.2.tar.gz"
  sha256 "728b6f7b3762d0dc38c8a6b6616e97934bfff1b218c63542bf67752994c8d40e"

  bottle do
    cellar :any_skip_relocation
    sha256 "1798f5fa4f5b5fbf6079b47623da47b2da7d04325e76c596a3efb37566b80610" => :el_capitan
    sha256 "6afc0b96930d393afcadceb712465b153fffb703fa538d563d9019462b077497" => :yosemite
    sha256 "e6d61ca437a7d2349205ef291704fc23eaaf3ec514c9dd8d26f08895d4000875" => :mavericks
  end

  depends_on "go" => :build

  resource "envman" do
    url "https://github.com/bitrise-io/envman/archive/0.9.10.tar.gz"
    sha256 "ca1912d53c495d1a5492c81df25591baae86126e6d9cf556f8d35f22a46ea95c"
  end

  resource "stepman" do
    url "https://github.com/bitrise-io/stepman/archive/0.9.17.tar.gz"
    sha256 "d4eee2cc46f63f3c842d86d9c04f0de71541eaff45d817d16ffd116673383ee8"
  end

  def go_install_package(basepth, pkgname)
    mkdir_p "#{basepth}/src/github.com/bitrise-io"
    ln_s basepth, "#{basepth}/src/github.com/bitrise-io/#{pkgname}"

    ENV["GOPATH"] = "#{basepth}/Godeps/_workspace:#{basepth}"
    Language::Go.stage_deps resources, "#{basepth}/src"
    system "go", "build", "-o", "#{bin}/#{pkgname}"
  end

  def install
    resource("envman").stage do
      go_install_package(Dir.pwd, "envman")
    end

    resource("stepman").stage do
      go_install_package(Dir.pwd, "stepman")
    end

    go_install_package(buildpath, "bitrise")
  end

  test do
    (testpath/"bitrise.yml").write <<-EOS.undent
      format_version: 1.1.0
      default_step_lib_source: https://github.com/bitrise-io/bitrise-steplib.git
      workflows:
        test_wf:
          steps:
          - script:
              inputs:
              - content: printf 'Test - OK' > brew.test.file
    EOS

    # setup with --minimal flag, to skip the included `brew doctor` check
    system "#{bin}/bitrise", "setup", "--minimal"
    # run the defined test_wf workflow
    system "#{bin}/bitrise", "run", "test_wf"
    assert_equal "Test - OK", (testpath/"brew.test.file").read.chomp
  end
end
