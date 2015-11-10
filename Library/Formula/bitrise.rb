require "language/go"

class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.2.3.tar.gz"
  sha256 "f884a0066503e8f344f99e59a57e3015476fa09ae898cd53cd664a045fbfc7cd"

  bottle do
    cellar :any_skip_relocation
    sha256 "5c6b979dd4985f0e4e404b8095e07b7c56f1c57247bbbf7d8c5968637de8f987" => :el_capitan
    sha256 "def03fa711dcb8b875e30ff2d9e26b91f8c873add84fa3ddcedf1f87b191cb12" => :yosemite
    sha256 "8fd6e7e71d448cbbb82487141a8415f98343df3157e161ab05798c605bdb5ee0" => :mavericks
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
