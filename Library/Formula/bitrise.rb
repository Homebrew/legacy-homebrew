require "language/go"

class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.0.0.tar.gz"
  sha256 "364476e0bbdb75a09c2b500b83e3049293c47679d4fb9023a53addc4a61eb9f3"

  bottle do
    cellar :any
    sha256 "940b3051270045f84827c434b94ed05d71a3ed132ba7149f4bcebfd216fc80ae" => :yosemite
    sha256 "629df7463e14407f0f5fb4c1eafe384214bcf43433897eec592d5141018dc809" => :mavericks
    sha256 "dd9196e0a5f6e8986ca5308905dbe3dde273ac342c5583a268600d135406acc9" => :mountain_lion
  end

  depends_on "go" => :build

  resource "envman" do
    url "https://github.com/bitrise-io/envman/archive/0.9.8.tar.gz"
    sha256 "21a952dfe4f0e27ed9d340fe1a445942b6429cf9cc04b6ca04e72a5bb577c939"
  end

  resource "stepman" do
    url "https://github.com/bitrise-io/stepman/archive/0.9.14.tar.gz"
    sha256 "e8153e409009d15f2a74909ccceb1cf616500da06e0e0071ac39b1b42821dff2"
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
