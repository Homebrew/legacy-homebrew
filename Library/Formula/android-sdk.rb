require "base64"

class AndroidSdk < Formula
  desc "Android API libraries and developer tools"
  homepage "https://developer.android.com/index.html"
  url "https://dl.google.com/android/android-sdk_r24.4.1-macosx.zip"
  version "24.4.1"
  sha256 "ce1638cb48526a0e55857fc46b57eda4349e6512006244ad13dd6c1361c74104"
  revision 1

  bottle do
    cellar :any
    sha256 "d38989fcd9b2fcf731be79ae24834d6f50f425dd44003a149b7dea6b323a4718" => :el_capitan
    sha256 "dac31fa15cb355141d8f6df68f15e21aba584d869d6d88967740fa803c191464" => :yosemite
    sha256 "4dacf5677233c1f227d22eccc09717e1b0fc16a7a9ec0f78a95e156441c459d7" => :mavericks
  end

  depends_on :macos => :mountain_lion

  conflicts_with "android-platform-tools",
    :because => "The Android Platform-Tools need to be installed as part of the SDK."

  resource "completion" do
    url "https://android.googlesource.com/platform/sdk/+/7859e2e738542baf96c15e6c8b50bbdb410131b0/bash_completion/adb.bash?format=TEXT"
    mirror "https://raw.githubusercontent.com/Homebrew/patches/c3b801f/android-sdk/adb.bash"
    sha256 "44b3e20ed9cb8fff01dc6907a57bd8648cd0d1bcc7b129ec952a190983ab5e1a"
  end

  # Version of the android-build-tools the wrapper scripts reference.
  def build_tools_version
    "23.0.1"
  end

  def install
    prefix.install "tools", "SDK Readme.txt" => "README"

    %w[android ddms draw9patch emulator
       emulator-arm emulator-x86 hierarchyviewer lint mksdcard
       monitor monkeyrunner traceview].each do |tool|
      (bin/tool).write <<-EOS.undent
        #!/bin/bash
        TOOL="#{prefix}/tools/#{tool}"
        exec "$TOOL" "$@"
      EOS
    end

    %w[zipalign].each do |tool|
      (bin/tool).write <<-EOS.undent
        #!/bin/bash
        TOOL="#{prefix}/build-tools/#{build_tools_version}/#{tool}"
        exec "$TOOL" "$@"
      EOS
    end

    %w[dmtracedump etc1tool hprof-conv].each do |tool|
      (bin/tool).write <<-EOS.undent
        #!/bin/bash
        TOOL="#{prefix}/platform-tools/#{tool}"
        exec "$TOOL" "$@"
      EOS
    end

    # this is data that should be preserved across upgrades, but the Android
    # SDK isn't too smart, so we still have to symlink it back into its tree.
    %w[platforms samples temp add-ons sources system-images extras].each do |d|
      src = var/"lib/android-sdk"/d
      src.mkpath
      prefix.install_symlink src
    end

    %w[adb fastboot].each do |platform_tool|
      (bin/platform_tool).write <<-EOS.undent
        #!/bin/bash
        PLATFORM_TOOL="#{prefix}/platform-tools/#{platform_tool}"
        test -x "$PLATFORM_TOOL" && exec "$PLATFORM_TOOL" "$@"
        echo "It appears you do not have 'Android SDK Platform-tools' installed."
        echo "Use the 'android' tool to install them: "
        echo "    android update sdk --no-ui --filter 'platform-tools'"
      EOS
    end

    %w[aapt aidl dexdump dx llvm-rs-cc].each do |build_tool|
      (bin/build_tool).write <<-EOS.undent
        #!/bin/bash
        BUILD_TOOLS_VERSION='#{build_tools_version}'
        BUILD_TOOL="#{prefix}/build-tools/$BUILD_TOOLS_VERSION/#{build_tool}"
        test -x "$BUILD_TOOL" && exec "$BUILD_TOOL" "$@"
        echo "It appears you do not have 'build-tools-$BUILD_TOOLS_VERSION' installed."
        echo "Use the 'android' tool to install them: "
        echo "    android update sdk --no-ui --filter 'build-tools-$BUILD_TOOLS_VERSION'"
      EOS
    end

    resource("completion").stage do
      # googlesource.com only serves up the file in base64-encoded format; we
      # need to decode it before installing
      decoded_file = buildpath/"adb-completion.bash"
      decoded_file.write Base64.decode64(File.read("adb.bash"))
      bash_completion.install decoded_file
    end

    # automatically install platform and build tools
    system "echo y | bash #{bin}/android --verbose update sdk --no-ui --all --filter platform-tools,build-tools-#{build_tools_version}"
  end

  def caveats; <<-EOS.undent
    Now run the 'android' tool to install the actual SDK stuff.

    The Android-SDK is available at #{opt_prefix}

    You may need to add the following to your .bashrc:
      export ANDROID_HOME=#{opt_prefix}
    EOS
  end
end
