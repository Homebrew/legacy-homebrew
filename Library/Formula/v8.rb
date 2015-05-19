# Track Chrome stable.
# https://github.com/v8/v8-git-mirror/commits/901b67916
# https://omahaproxy.appspot.com/

class V8 < Formula
  desc "Google's JavaScript engine"
  homepage "https://code.google.com/p/v8/"
  url "https://github.com/v8/v8-git-mirror/archive/4.1.0.27.tar.gz"
  sha256 "88bafa0bf80154f8f00e9808acd90a9233c0589c5da46ac4ebe3489ce914b87a"

  bottle do
    cellar :any
    sha256 "e089d591be39c02780383607dfa75786baff911c8691129792ad2761202aabf9" => :yosemite
    sha256 "b4727655d6f46b416571d7c522db41f770cc0c74d87ca8e560b6d673aaef8687" => :mavericks
    sha256 "043d0048611cbbbc3cfc4c6a95a92ebcc6c70e9b9510a1bce1091110788e6d62" => :mountain_lion
  end

  option "with-readline", "Use readline instead of libedit"

  # not building on Snow Leopard:
  # https://github.com/Homebrew/homebrew/issues/21426
  depends_on :macos => :lion

  depends_on :python => :build # gyp doesn't run under 2.6 or lower
  depends_on "readline" => :optional

  # Update from "DEPS" file in tarball.
  resource "gyp" do
    url "https://chromium.googlesource.com/external/gyp.git",
        :revision => "fe00999dfaee449d3465a9316778434884da4fa7"
    version "2010"
  end

  resource "gmock" do
    url "http://googlemock.googlecode.com/svn/trunk", :revision => 501
    version "501"
  end

  resource "gtest" do
    url "http://googletest.googlecode.com/svn/trunk", :revision => 700
    version "700"
  end

  def install
    # fix up libv8.dylib install_name
    # https://github.com/Homebrew/homebrew/issues/36571
    # https://code.google.com/p/v8/issues/detail?id=3871
    inreplace "tools/gyp/v8.gyp",
              "'OTHER_LDFLAGS': ['-dynamiclib', '-all_load']",
              "\\0, 'DYLIB_INSTALL_NAME_BASE': '#{opt_lib}'"

    # Download gyp ourselves because running "make dependencies" pulls in ICU.
    (buildpath/"build/gyp").install resource("gyp")
    (buildpath/"testing/gmock").install resource("gmock")
    (buildpath/"testing/gtest").install resource("gtest")

    system "make", "native", "library=shared", "snapshot=on",
                   "console=readline", "i18nsupport=off"

    prefix.install "include"

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
