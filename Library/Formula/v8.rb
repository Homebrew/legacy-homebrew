# Track Chrome stable.
# https://omahaproxy.appspot.com/
class V8 < Formula
  desc "Google's JavaScript engine"
  homepage "https://code.google.com/p/v8/"
  url "https://github.com/v8/v8-git-mirror/archive/4.9.385.28.tar.gz"
  sha256 "c77c5f9d5b6c77186485a99da459c604738d1d2d299c8224a4781cbe8227a8b9"

  bottle do
    cellar :any
    sha256 "5df273afd3d0273026bef73f0411395f0de8868823a14f0d05f85d0ec852164c" => :el_capitan
    sha256 "41dc7013808f28d6ffa1f6b9fc3dc06642b384ee0efebb1038d0470ec6919abd" => :yosemite
    sha256 "2d4be792d0945b762d926f156ae134b3fbed27a45d8e05b364debcdf22e65c92" => :mavericks
  end

  option "with-readline", "Use readline instead of libedit"

  # not building on Snow Leopard:
  # https://github.com/Homebrew/homebrew/issues/21426
  depends_on :macos => :lion

  depends_on :python => :build # gyp doesn't run under 2.6 or lower
  depends_on "readline" => :optional
  depends_on "icu4c" => :optional

  needs :cxx11

  # Update from "DEPS" file in tarball.
  # Note that we don't require the "test" DEPS because we don't run the tests.
  resource "gyp" do
    url "https://chromium.googlesource.com/external/gyp.git",
        :revision => "ed163ce233f76a950dce1751ac851dbe4b1c00cc"
  end

  resource "icu" do
    url "https://chromium.googlesource.com/chromium/deps/icu.git",
        :revision => "e466f6ac8f60bb9697af4a91c6911c6fc4aec95f"
  end

  resource "buildtools" do
    url "https://chromium.googlesource.com/chromium/buildtools.git",
        :revision => "14288a03a92856fe1fc296d39e6a25c2d83cd6cf"
  end

  resource "common" do
    url "https://chromium.googlesource.com/chromium/src/base/trace_event/common.git",
        :revision => "e40c41030f44cbd5b6f54081436620f43c3bb08a"
  end

  resource "swarming_client" do
    url "https://chromium.googlesource.com/external/swarming.client.git",
        :revision => "df6e95e7669883c8fe9ef956c69a544154701a49"
  end

  resource "gtest" do
    url "https://chromium.googlesource.com/external/github.com/google/googletest.git",
        :revision => "6f8a66431cb592dad629028a50b3dd418a408c87"
  end

  resource "gmock" do
    url "https://chromium.googlesource.com/external/googlemock.git",
        :revision => "0421b6f358139f02e102c9c332ce19a33faf75be"
  end

  resource "clang" do
    url "https://chromium.googlesource.com/chromium/src/tools/clang.git",
        :revision => "3183208ae119c48012bed71645cb2ca537120811"
  end

  def install
    # Bully GYP into correctly linking with c++11
    ENV.cxx11
    ENV["GYP_DEFINES"] = "clang=1 mac_deployment_target=#{MacOS.version}"
    # https://code.google.com/p/v8/issues/detail?id=4511#c3
    ENV.append "GYP_DEFINES", "v8_use_external_startup_data=0"

    if build.with? "icu4c"
      ENV.append "GYP_DEFINES", "use_system_icu=1"
      i18nsupport = "i18nsupport=on"
    else
      i18nsupport = "i18nsupport=off"
    end

    # fix up libv8.dylib install_name
    # https://github.com/Homebrew/homebrew/issues/36571
    # https://code.google.com/p/v8/issues/detail?id=3871
    inreplace "tools/gyp/v8.gyp",
              "'OTHER_LDFLAGS': ['-dynamiclib', '-all_load']",
              "\\0, 'DYLIB_INSTALL_NAME_BASE': '#{opt_lib}'"

    (buildpath/"build/gyp").install resource("gyp")
    (buildpath/"third_party/icu").install resource("icu")
    (buildpath/"buildtools").install resource("buildtools")
    (buildpath/"base/trace_event/common").install resource("common")
    (buildpath/"tools/swarming_client").install resource("swarming_client")
    (buildpath/"testing/gtest").install resource("gtest")
    (buildpath/"testing/gmock").install resource("gmock")
    (buildpath/"tools/clang").install resource("clang")

    system "make", "native", "library=shared", "snapshot=on",
                   "console=readline", i18nsupport,
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
