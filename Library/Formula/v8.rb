# Track Chrome stable.
# https://omahaproxy.appspot.com/
class V8 < Formula
  desc "Google's JavaScript engine"
  homepage "https://code.google.com/p/v8/"
  url "https://github.com/v8/v8-git-mirror/archive/4.8.271.17.tar.gz"
  sha256 "825217b40e6730ed2d2c52ffdaefee861795687c240dd39670f3e0ecc6f25dfb"

  bottle do
    cellar :any
    sha256 "2b45ff1e2afccc61cd02669fd87ed6e9f1a8a38b1970e17ac8360c269f59e215" => :el_capitan
    sha256 "05b48079fbb41a44ed69114bf74939852576931c60f380618a2877bd0cbfb2f3" => :yosemite
    sha256 "b058fdee91f7458ea1feff9c92370b9f8056fb4cfd1eb792789004e24302271e" => :mavericks
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
        :revision => "2c1e6cced23554ce84806e570acea637f6473afc"
  end

  resource "icu" do
    url "https://chromium.googlesource.com/chromium/deps/icu.git",
        :revision => "42c58d4e49f2250039f0e98d43e0b76e8f5ca024"
  end

  resource "buildtools" do
    url "https://chromium.googlesource.com/chromium/buildtools.git",
        :revision => "4a95614772d9bcbd8bc197e1d9bd034e088fc740"
  end

  resource "swarming_client" do
    url "https://chromium.googlesource.com/external/swarming.client.git",
        :revision => "8fce79620b04bbe5415ace1103db27505bdc4c06"
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
        :revision => "66f5328417331216569e8beb244fd887f62e8997"
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
