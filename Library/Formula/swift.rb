class Swift < Formula
  desc "High-performance system programming language"
  homepage "https://github.com/apple/swift"
  url "https://github.com/apple/swift/archive/swift-2.2-SNAPSHOT-2015-12-18-a.tar.gz"
  version "2.2-SNAPSHOT-2015-12-18-a"
  sha256 "2ff6c780f1768e410e444915d6830048025a7f353c9a4bc30456bbd40ad33951"

  stable do
    swift_tag = "swift-#{version}"

    resource "cmark" do
      url "https://github.com/apple/swift-cmark/archive/0.22.0.tar.gz"
      sha256 "7fa11223b9a29a411fbc440aba2a756ccc8b6228d8c2b367e8f568968e3eb569"
    end

    resource "clang" do
      url "https://github.com/apple/swift-clang/archive/#{swift_tag}.tar.gz"
      sha256 "a626feb26119cde3f9df15549d8a53028c704c5deba5e84b60ba434398a529da"
    end

    resource "llvm" do
      url "https://github.com/apple/swift-llvm/archive/#{swift_tag}.tar.gz"
      sha256 "6d69cd1ea9bb830bc7f21a80c30d5be29e55878b9f9f46ef4faa2fd02d36b160"
    end
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
      system "#{buildpath}/utils/build-script-impl",
        "--build-dir=#{build}",
        "--cmark-build-type=Release",
        "--llvm-build-type=Release",
        "--swift-build-type=Release",
        "--swift-stdlib-build-type=Release",
        "--lldb-build-type=Release",
        "--llvm-enable-assertions=false",
        "--swift-enable-assertions=false",
        "--swift-stdlib-enable-assertions=false",
        "--cmake-generator=Ninja",
        "--workspace=#{workspace}",
        "--skip-test-cmark",
        "--skip-test-lldb",
        "--skip-test-swift",
        "--skip-test-llbuild",
        "--skip-test-swiftpm",
        "--skip-test-xctest",
        "--skip-test-foundation",
        "--skip-test-validation",
        "--skip-test-optimized",
        "--skip-build-lldb",
        "--skip-build-llbuild",
        "--skip-build-swiftpm",
        "--skip-build-xctest",
        "--skip-build-foundation",
        "--build-args=-j#{ENV.make_jobs}",
        "--lldb-use-system-debugserver",
        "--install-prefix=#{prefix}",
        "--skip-ios",
        "--skip-tvos",
        "--skip-watchos",
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
