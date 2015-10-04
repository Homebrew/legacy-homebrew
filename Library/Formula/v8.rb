# Track Chrome stable.
# https://omahaproxy.appspot.com/
class V8 < Formula
  desc "Google's JavaScript engine"
  homepage "https://code.google.com/p/v8/"
  url "https://github.com/v8/v8-git-mirror/archive/4.5.103.35.tar.gz"
  sha256 "93de92efb1185384e0b3a046aae8816138b3ccb6f5bc148ad59d94a9a2869aaa"

  bottle do
    cellar :any
    sha256 "6647353a6717a0028e7e627e85fe1e943cf68869f95d2250a662b167ddc50c29" => :el_capitan
    sha256 "0f577159738f985afbc85fa47c52b32c0551922cadbf1ad24895a8737d70cecc" => :yosemite
    sha256 "affd5c033afa20e071b60f05f5de78d00eaedd67df7f1f305645c8dcfb41774d" => :mavericks
  end

  option "with-readline", "Use readline instead of libedit"

  # not building on Snow Leopard:
  # https://github.com/Homebrew/homebrew/issues/21426
  depends_on :macos => :lion

  depends_on :python => :build # gyp doesn't run under 2.6 or lower
  depends_on "readline" => :optional

  needs :cxx11

  # Update from "DEPS" file in tarball.
  resource "gyp" do
    url "https://chromium.googlesource.com/external/gyp.git",
        :revision => "5122240c5e5c4d8da12c543d82b03d6089eb77c5"
  end

  resource "icu" do
    url "https://chromium.googlesource.com/chromium/deps/icu.git",
        :revision => "c81a1a3989c3b66fa323e9a6ee7418d7c08297af"
  end

  resource "buildtools" do
    url "https://chromium.googlesource.com/chromium/buildtools.git",
        :revision => "ecc8e253abac3b6186a97573871a084f4c0ca3ae"
  end

  resource "clang" do
    url "https://chromium.googlesource.com/chromium/src/tools/clang.git",
        :revision => "73ec8804ed395b0886d6edf82a9f33583f4a7902"
  end

  resource "gmock" do
    url "https://chromium.googlesource.com/external/googlemock.git",
        :revision => "29763965ab52f24565299976b936d1265cb6a271"
  end

  resource "gtest" do
    url "https://chromium.googlesource.com/external/googletest.git",
        :revision => "23574bf2333f834ff665f894c97bef8a5b33a0a9"
  end

  def install
    # Bully GYP into correctly linking with c++11
    ENV.cxx11
    ENV["GYP_DEFINES"] = "clang=1 mac_deployment_target=#{MacOS.version}"

    # fix up libv8.dylib install_name
    # https://github.com/Homebrew/homebrew/issues/36571
    # https://code.google.com/p/v8/issues/detail?id=3871
    inreplace "tools/gyp/v8.gyp",
              "'OTHER_LDFLAGS': ['-dynamiclib', '-all_load']",
              "\\0, 'DYLIB_INSTALL_NAME_BASE': '#{opt_lib}'"

    (buildpath/"buildtools").install resource("buildtools")
    (buildpath/"build/gyp").install resource("gyp")
    (buildpath/"third_party/icu").install resource("icu")
    (buildpath/"testing/gmock").install resource("gmock")
    (buildpath/"testing/gtest").install resource("gtest")
    (buildpath/"tools/clang").install resource("clang")

    system "make", "native", "library=shared", "snapshot=on",
                   "console=readline", "i18nsupport=off",
                   "strictaliasing=off"

    include.install Dir["include/*"]

    cd "out/native" do
      rm ["libgmock.a", "libgtest.a"]
      lib.install Dir["lib*"]
      bin.install "d8", "mksnapshot", "process", "shell" => "v8"
    end
  end

  test do
    assert_equal "Hello World!", pipe_output("#{bin}/v8 -e 'print(\"Hello World!\")'").chomp
  end
end
