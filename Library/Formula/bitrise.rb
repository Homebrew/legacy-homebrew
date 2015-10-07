require "language/go"

class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.2.1.tar.gz"
  sha256 "5fe71fc2461dd6c1aee10a3178c1c768848b638e21c29ff2ba6ade4c2a68a1b7"

  bottle do
    cellar :any_skip_relocation
    sha256 "4a13574be7cde8d80107e61f06ee6357c6c2e345247f6b152e5151cec6409919" => :el_capitan
    sha256 "0b4b7ee7555cd3adb3b66f97bcf15a968bbeaa60da68d28b6d68213945d22362" => :yosemite
    sha256 "d014dd50793d58e7943a5ad10239488ea73375051478ce7b0ec18e15be255f90" => :mavericks
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
