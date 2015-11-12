# Track Chrome stable.
# https://omahaproxy.appspot.com/
class V8 < Formula
  desc "Google's JavaScript engine"
  homepage "https://code.google.com/p/v8/"
  url "https://github.com/v8/v8-git-mirror/archive/4.6.85.31.tar.gz"
  sha256 "6034b20794bcdc3190db8fe1614c458daee7ac36449131dd29444200bb7bbc6d"

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
        :revision => "6ee91ad8659871916f9aa840d42e1513befdf638"
  end

  resource "icu" do
    url "https://chromium.googlesource.com/chromium/deps/icu.git",
        :revision => "89dcdec16381883782b9cc9cff38e00f047a0f46"
  end

  resource "buildtools" do
    url "https://chromium.googlesource.com/chromium/buildtools.git",
        :revision => "565d04e8741429fb1b4f26d102f2c6c3b849edeb"
  end

  resource "clang" do
    url "https://chromium.googlesource.com/chromium/src/tools/clang.git",
        :revision => "5b12e334ec0e571a8e1f68d028dc5427b58c17ec"
  end

  resource "gmock" do
    url "https://chromium.googlesource.com/external/googlemock.git",
        :revision => "0421b6f358139f02e102c9c332ce19a33faf75be"
  end

  resource "gtest" do
    url "https://chromium.googlesource.com/external/googletest.git",
        :revision => "9855a87157778d39b95eccfb201a9dc90f6d61c6"
  end

  def install
    # Bully GYP into correctly linking with c++11
    ENV.cxx11
    ENV["GYP_DEFINES"] = "clang=1 mac_deployment_target=#{MacOS.version}"
    # https://code.google.com/p/v8/issues/detail?id=4511#c3
    ENV.append "GYP_DEFINES", "v8_use_external_startup_data=0"

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
