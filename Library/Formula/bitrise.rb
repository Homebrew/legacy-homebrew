require "language/go"

class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/0.9.11.tar.gz"
  sha256 "dee1418f188480e125555a47981e2c28b0972e21181606648cf3b5d7a298e084"

  bottle do
    cellar :any
    sha256 "940b3051270045f84827c434b94ed05d71a3ed132ba7149f4bcebfd216fc80ae" => :yosemite
    sha256 "629df7463e14407f0f5fb4c1eafe384214bcf43433897eec592d5141018dc809" => :mavericks
    sha256 "dd9196e0a5f6e8986ca5308905dbe3dde273ac342c5583a268600d135406acc9" => :mountain_lion
  end

  depends_on "go" => :build

  resource "envman" do
    url "https://github.com/bitrise-io/envman/archive/0.9.7.tar.gz"
    sha256 "8ee00feae482768e80c86652dd99fa821353e9a1a20ca4fbad19d1635cfb013a"
  end

  resource "stepman" do
    url "https://github.com/bitrise-io/stepman/archive/0.9.12.tar.gz"
    sha256 "7a4f9175046f182b4bcea9f35839870f56bf7bdde32cc221ac67e6de37e1cae4"
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
      format_version: 0.9.10
      default_step_lib_source: https://github.com/bitrise-io/bitrise-steplib
      workflows:
        test_wf:
          steps:
          - script:
              title: Write a test string to a file, for compare
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
