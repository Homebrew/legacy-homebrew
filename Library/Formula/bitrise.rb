require "language/go"

class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.2.4.tar.gz"
  sha256 "7cf365dca04ac2adadea1fbe286a117336460daa2488b0e62dc080b8ac868a09"

  bottle do
    cellar :any_skip_relocation
    sha256 "3c9c6d4c4a135d79fe4dfabf93e33550e3fb3d207d366bcbe7cfe13d88a66fdc" => :el_capitan
    sha256 "91723eb65af76465347356047ed7c38ce26b1e73bb578fc5e51d7c5336407a83" => :yosemite
    sha256 "0f32b8a62ab83e509a2dfdfbc4df9eb333b0e7d4a0eb59ccb18e50760ed7343d" => :mavericks
  end

  depends_on "go" => :build

  resource "envman" do
    url "https://github.com/bitrise-io/envman/archive/1.0.0.tar.gz"
    sha256 "439d6c1732c3f2dbe121750ba1951df126576e393ce1028426a70dcaafcffe3a"
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
