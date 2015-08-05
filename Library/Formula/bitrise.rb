require "language/go"

class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/0.9.9.tar.gz"
  sha256 "2caabe23069a46d7b158976d43d8f6965cb6b382f3c7409097e943a3908ee938"

  bottle do
    cellar :any
    sha256 "8d8cdcda113f12ab497db0700a04849143e733e2cf9c35c5e028b434f694d67c" => :yosemite
    sha256 "9eb2435bdc04f4acaf975a5adf7bbbcced64c6ac60a678696919d67e59f04ef4" => :mavericks
    sha256 "54e66ee1699983c1bb4a9662a8ff66a2e50aac85cd0eb0c613513b6cffa004b7" => :mountain_lion
  end

  depends_on "go" => :build

  resource "envman" do
    url "https://github.com/bitrise-io/envman/archive/0.9.4.tar.gz"
    sha256 "29e014b7dd5854d2ee4d4cb13453216aaf15b223b5d20128bb6739881a490b2f"
  end

  resource "stepman" do
    url "https://github.com/bitrise-io/stepman/archive/0.9.8.tar.gz"
    sha256 "ddec848b433afa89390b5b05abe2fcabfe9fd0ac88c4cbca7fbf327925d49415"
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
      format_version: 0.9.8
      default_step_lib_source: https://github.com/bitrise-io/bitrise-steplib
      app:
        envs: []
      workflows:
        test_wf:
          title: Workflow for master branch
          envs: []
          steps:
          - script:
              title: Test
              inputs:
              - content: |-
                  #!/bin/bash
                  set -e
                  pwd
                  printf 'Test - OK' > brew.test.file
    EOS

    system "#{bin}/bitrise", "run", "test_wf"
    assert_equal "Test - OK", (testpath/"brew.test.file").read.chomp
  end
end
