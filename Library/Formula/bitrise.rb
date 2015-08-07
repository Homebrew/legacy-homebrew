require "language/go"

class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/0.9.7.tar.gz"
  sha256 "cecd0cd112941c6b6f9d6cd334ea6a31aef1123af89e17c3950fbc8e8dbe5de2"

  bottle do
    cellar :any
    sha256 "8d8cdcda113f12ab497db0700a04849143e733e2cf9c35c5e028b434f694d67c" => :yosemite
    sha256 "9eb2435bdc04f4acaf975a5adf7bbbcced64c6ac60a678696919d67e59f04ef4" => :mavericks
    sha256 "54e66ee1699983c1bb4a9662a8ff66a2e50aac85cd0eb0c613513b6cffa004b7" => :mountain_lion
  end

  depends_on "go" => :build

  resource "envman" do
    url "https://github.com/bitrise-io/envman/archive/0.9.3.tar.gz"
    sha256 "ff9cb03f978332499bad52f4930f736ded2f8573e8b713b5082f65432e618b8f"
  end

  resource "stepman" do
    url "https://github.com/bitrise-io/stepman/archive/0.9.7.tar.gz"
    sha256 "1eae33616e9c1c952f7c3cfc677fecc0cf0f0781a4aa2e686969e74485284c89"
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
