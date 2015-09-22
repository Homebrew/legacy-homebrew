require "language/go"

class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.1.2.tar.gz"
  sha256 "95f381dce0c5bef8609f8e3af44a8e6844a5f7ac10e95d4d4ad78d7490bd60c8"

  bottle do
    cellar :any_skip_relocation
    sha256 "4a13574be7cde8d80107e61f06ee6357c6c2e345247f6b152e5151cec6409919" => :el_capitan
    sha256 "0b4b7ee7555cd3adb3b66f97bcf15a968bbeaa60da68d28b6d68213945d22362" => :yosemite
    sha256 "d014dd50793d58e7943a5ad10239488ea73375051478ce7b0ec18e15be255f90" => :mavericks
  end

  depends_on "go" => :build

  resource "envman" do
    url "https://github.com/bitrise-io/envman/archive/0.9.8.tar.gz"
    sha256 "21a952dfe4f0e27ed9d340fe1a445942b6429cf9cc04b6ca04e72a5bb577c939"
  end

  resource "stepman" do
    url "https://github.com/bitrise-io/stepman/archive/0.9.16.tar.gz"
    sha256 "b2f99d31c7fbaa230759647c2aea42c88a762b32ef576951d6fc357287aaeb19"
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
      format_version: 1.0.0
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
