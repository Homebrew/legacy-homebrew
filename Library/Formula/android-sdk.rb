require "base64"

class AndroidSdk < Formula
  desc "Android API libraries and developer tools"
  homepage "https://developer.android.com/index.html"
  url "https://dl.google.com/android/android-sdk_r24.3.4-macosx.zip"
  version "24.3.4"
  sha256 "074da140b380177108b9b74869403df7a65c5b555d4f5e439fa8556f1018352b"

  conflicts_with "android-platform-tools",
    :because => "The Android Platform-Tools need to be installed as part of the SDK."

  resource "completion" do
    url "https://android.googlesource.com/platform/sdk/+/7859e2e738542baf96c15e6c8b50bbdb410131b0/bash_completion/adb.bash?format=TEXT"
    sha256 "44b3e20ed9cb8fff01dc6907a57bd8648cd0d1bcc7b129ec952a190983ab5e1a"
  end

  # Version of the android-build-tools the wrapper scripts reference.
  def build_tools_version
    "23.0.0"
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
  end

  def caveats; <<-EOS.undent
    Now run the 'android' tool to install the actual SDK stuff.

    The Android-SDK is available at #{opt_prefix}

    You will have to install the platform-tools and docs EVERY time this formula
    updates. If you want to try and fix this then see the comment in this formula.

    You may need to add the following to your .bashrc:
      export ANDROID_HOME=#{opt_prefix}
    EOS
  end

  # The 'android' tool insists on deleting #{prefix}/platform-tools
  # and then installing the new one. So it is impossible for us to redirect
  # the SDK location to var so that the platform-tools don't have to be
  # freshly installed EVERY DANG time the base SDK updates.

  # Ideas: make android a script that calls the actual android tool, but after
  # that tool exits it repairs the directory locations?
end
