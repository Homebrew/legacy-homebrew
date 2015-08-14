require "language/go"

class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/0.9.10.tar.gz"
  sha256 "4e76667c6992331f38da4e662cf54cc9375c3bf069af373b2183b7ef16ec7be7"

  bottle do
    cellar :any
    sha256 "8d8cdcda113f12ab497db0700a04849143e733e2cf9c35c5e028b434f694d67c" => :yosemite
    sha256 "9eb2435bdc04f4acaf975a5adf7bbbcced64c6ac60a678696919d67e59f04ef4" => :mavericks
    sha256 "54e66ee1699983c1bb4a9662a8ff66a2e50aac85cd0eb0c613513b6cffa004b7" => :mountain_lion
  end

  depends_on "go" => :build

  resource "envman" do
    url "https://github.com/bitrise-io/envman/archive/0.9.5.tar.gz"
    sha256 "94017e7b5840452e32264e20c9b5e3c268db074bbceb813bc2f4a50dc7fee5e0"
  end

  resource "stepman" do
    url "https://github.com/bitrise-io/stepman/archive/0.9.10.tar.gz"
    sha256 "1a11485dd809176baa20b7efa28debf21b9538afa8eda0cbc01f34cc1921eec1"
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
