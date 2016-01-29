class Swift < Formula
  desc "High-performance system programming language"
  homepage "https://github.com/apple/swift"
  url "https://github.com/apple/swift/archive/swift-2.2-SNAPSHOT-2016-01-25-a.tar.gz"
  version "2.2-SNAPSHOT-2016-01-25-a"
  sha256 "616cf1cfaa407ffb22cd60f9c5a95dc3227665c72dd5c8d044b31174430af3b6"

  stable do
    swift_tag = "swift-#{version}"

    resource "cmark" do
      url "https://github.com/apple/swift-cmark/archive/#{swift_tag}.tar.gz"
      sha256 "063469a810855a622bb05846b3f74fb0f0f92585e46c5ec16618188a71d21f24"
    end

    resource "clang" do
      url "https://github.com/apple/swift-clang/archive/#{swift_tag}.tar.gz"
      sha256 "eec56334ffcec1cefaca5758031c722a0cf12eb0d3fac30f9d30c1bded16eeea"
    end

    resource "llvm" do
      url "https://github.com/apple/swift-llvm/archive/#{swift_tag}.tar.gz"
      sha256 "7b07af901b6fe42793e4f25a470db8d61c60c16b92e434de17fc151861e00172"
    end

    resource "swiftpm" do
      url "https://github.com/apple/swift-package-manager/archive/swift-DEVELOPMENT-SNAPSHOT-2016-01-25-a.tar.gz"
      sha256 "84105f264f16755e27a0ebc8d25de51c1d72a33007b61ad68eb0ea185f15b0a8"
    end

    resource "llbuild" do
      url "https://github.com/apple/swift-llbuild/archive/swift-DEVELOPMENT-SNAPSHOT-2016-01-25-a.tar.gz"
      sha256 "dbf0aa2b04d04cce2281b452008506ffbe140d47c3a4d933ad715e6ee1ccdf06"
    end
  end

  bottle do
    sha256 "d68a3462b09fd3746605fc8877b13f12d8772b143b0da9e8759d5e61a6f5699e" => :el_capitan
    sha256 "48c36f01a912a6f466449a44d7e5bbad90a6a618379b13e4ea5a0d2fcae980cd" => :yosemite
  end

  head do
    url "https://github.com/apple/swift.git"

    resource "cmark" do
      url "https://github.com/apple/swift-cmark.git"
    end

    resource "clang" do
      url "https://github.com/apple/swift-clang.git", :branch => "stable"
    end

    resource "llvm" do
      url "https://github.com/apple/swift-llvm.git", :branch => "stable"
    end

    resource "swiftpm" do
      url "https://github.com/apple/swift-package-manager.git"
    end

    resource "llbuild" do
      url "https://github.com/apple/swift-llbuild.git"
    end
  end

  keg_only :provided_by_osx, "Apple's CLT package contains Swift."

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on :xcode => ["7.0", :build]

  def install
    workspace = buildpath.parent
    build = workspace/"build"

    ln_sf buildpath, "#{workspace}/swift"
    resources.each { |r| r.stage("#{workspace}/#{r.name}") }

    mkdir build do
      system "#{buildpath}/utils/build-script",
        "-R",
        "--swiftpm",
        "--llbuild",
        "--build-subdir=",
        "--no-llvm-assertions",
        "--no-swift-assertions",
        "--no-swift-stdlib-assertions",
        "--",
        "--workspace=#{workspace}",
        "--build-args=-j#{ENV.make_jobs}",
        "--lldb-use-system-debugserver",
        "--install-prefix=#{prefix}",
        "--darwin-deployment-version-osx=#{MacOS.version}",
        "--build-jobs=#{ENV.make_jobs}"
    end
    bin.install "#{build}/swift-macosx-x86_64/bin/swift",
                "#{build}/swift-macosx-x86_64/bin/swiftc"
    (lib/"swift").install "#{build}/swift-macosx-x86_64/lib/swift/macosx/",
                          "#{build}/swift-macosx-x86_64/lib/swift/shims/"
  end

  test do
    (testpath/"test.swift").write 'print("test")'
    system "#{bin}/swiftc", "test.swift"
    assert_equal "test\n", shell_output("./test")
  end
end
