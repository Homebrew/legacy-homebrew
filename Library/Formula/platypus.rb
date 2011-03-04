require 'formula'

class Platypus <Formula
  url 'http://www.sveinbjorn.org/files/software/platypus.src.zip'
  version '4.2'
  homepage 'http://www.sveinbjorn.org/platypus'
  md5 '238f3c28b30a35ee86961c31f2ff5cff'

  def install
    # Fix paths
    inreplace "CommonDefs.h" do |s|
      s.gsub! "/usr/local", prefix
    end

    # Build main command-line binary, we don't care about the App
    Dir.chdir('command_line_tool') do
      # Fix paths
      inreplace ["platypus.m", "platypus.1"] do |s|
        s.gsub! "/usr/local", prefix
      end

      # Build binary
      system "xcodebuild", "-target", "platypus", "-configuration", "Deployment", "ONLY_ACTIVE_ARCH=YES", "SDKROOT=", "MACOSX_DEPLOYMENT_TARGET="
    end
    # Build application sub-binary needed by command-line utility
    Dir.chdir('Script_Exec') do
      system "xcodebuild", "-target", "ScriptExec", "-configuration", "Release", "ONLY_ACTIVE_ARCH=YES", "SDKROOT=", "MACOSX_DEPLOYMENT_TARGET="
    end

    # Install binary and man page
    Dir.chdir('command_line_tool') do
      bin.install "build/Deployment/platypus"
      man1.install "platypus.1"
    end
    # Install sub-binary parts to share
    Dir.chdir('Script_Exec/build/Release/ScriptExec.app/Contents') do
      (share + 'platypus').install "MacOS/ScriptExec"
      (share + 'platypus/MainMenu.nib').install "Resources/English.lproj/MainMenu.nib/keyedobjects.nib"
    end

    # Install icons to share
    (share + 'platypus').install 'Icons/PlatypusDefault.icns'

    # Write version info to share
    (share + 'platypus/Version').write version
  end
end
