class Swift < Formula
  desc "High-performance system programming language"
  homepage "https://github.com/apple/swift"
  url "https://github.com/apple/swift/archive/swift-2.2-SNAPSHOT-2015-12-31-a.tar.gz"
  version "2.2-SNAPSHOT-2015-12-31-a"
  sha256 "d899e995c9cfa8987e470f0ad799f311ba9d8ae54ca889c4a22e60ac44bea26a"

  stable do
    swift_tag = "swift-#{version}"

    resource "cmark" do
      url "https://github.com/apple/swift-cmark/archive/0.22.0.tar.gz"
      sha256 "7fa11223b9a29a411fbc440aba2a756ccc8b6228d8c2b367e8f568968e3eb569"
    end

    resource "clang" do
      url "https://github.com/apple/swift-clang/archive/#{swift_tag}.tar.gz"
      sha256 "9660637e380472e3c30244d43f0d56499483a10dd960a8ae5323a0ba374152a2"
    end

    resource "llvm" do
      url "https://github.com/apple/swift-llvm/archive/#{swift_tag}.tar.gz"
      sha256 "4730fb75898110ed892d4cc35f2f58b457879c51283b19cccf797c443b3bc05e"
    end
  end

  bottle do
    sha256 "d6702f2d52b0f570c3851e88605529e3102df8b3bf243d8c8db0cbe18b63d027" => :el_capitan
    sha256 "6d5ed861ec71459e6671a534f52e0e449e9025bdad1a6faab6dc3bc843aa4af8" => :yosemite
  end

  head do
    url "https://github.com/apple/swift"

    resource "cmark" do
      url "https://github.com/apple/swift-cmark.git"
    end

    resource "clang" do
      url "https://github.com/apple/swift-clang.git", :branch => "stable"
    end

    resource "llvm" do
      url "https://github.com/apple/swift-llvm.git", :branch => "stable"
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
