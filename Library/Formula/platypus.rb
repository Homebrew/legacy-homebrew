require 'formula'

class Platypus <Formula
  url 'http://www.sveinbjorn.org/files/software/platypus.src.zip'
  version '4.4'
  homepage 'http://www.sveinbjorn.org/platypus'
  md5 'e6fe23f7037a873394b70bcc62843940'

  def install
    # Fix paths
    inreplace ["CommonDefs.h", "CommandLineTool/platypus.1"] do |s|
      s.gsub! "/usr/local", prefix
    end

    # Build main command-line binary, we don't care about the App
    system "xcodebuild", "-target", "platypus", "-configuration", "Deployment", "ONLY_ACTIVE_ARCH=YES", "SYMROOT=build", "SDKROOT=", "MACOSX_DEPLOYMENT_TARGET="

    # Build application sub-binary needed by command-line utility
    system "xcodebuild", "-target", "ScriptExec", "-configuration", "Deployment", "ONLY_ACTIVE_ARCH=YES", "SYMROOT=build", "SDKROOT=", "MACOSX_DEPLOYMENT_TARGET="

    # Install binary and man page
    bin.install "build/Deployment/platypus"
    Dir.chdir('CommandLineTool') do
      man1.install "platypus.1"
    end
    # Install sub-binary parts to share
    Dir.chdir('build/Deployment/ScriptExec.app/Contents') do
      (share + 'platypus').install "MacOS/ScriptExec"
      (share + 'platypus/MainMenu.nib').install "Resources/English.lproj/MainMenu.nib/keyedobjects.nib"
    end

    # Install icons to share
    (share + 'platypus').install 'Icons/PlatypusDefault.icns'

    # Write version info to share
    (share + 'platypus/Version').write version
  end
end
