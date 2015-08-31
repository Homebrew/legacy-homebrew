require "language/go"

class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/0.9.11.tar.gz"
  sha256 "dee1418f188480e125555a47981e2c28b0972e21181606648cf3b5d7a298e084"

  bottle do
    cellar :any
    sha256 "ae8ad372e6dfeb1ca677f99022cab800abf6c916a8a771a313a6c76e1b618933" => :yosemite
    sha256 "31475f6587cd0ab9c5f901a34bdf99b6d9b77cc2b39e476b20fc2870e3717916" => :mavericks
    sha256 "fe4ec3878b6ce181e1ee8fba4f24bdf0d2bac043cb9dcd8d7ec0c9b12342a63e" => :mountain_lion
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
