require 'formula'

class NeedsSnowLeopard < Requirement
  def satisfied?
    MacOS.snow_leopard?
  end

  def message
    "jstalk requires Mac OS X 10.6 or newer"
  end
end

class Jstalk < Formula
  homepage 'http://jstalk.org/'
  url 'https://github.com/ccgus/jstalk.git', :tag => "v1.0.1"
  version '1.0.1'

  depends_on NeedsSnowLeopard.new

  def install
    ["JSTalk Framework", "jstalk command line", "JSTalk Editor"].each do |t|
      system "xcodebuild", "-target", t, "-configuration", "Release", "ONLY_ACTIVE_ARCH=YES", "SYMROOT=build"
    end

    cd 'build/Release' do
      bin.install 'jstalk'
      prefix.install "JSTalk Editor.app"
      (prefix+'Frameworks').install 'JSTalk.framework'
    end
  end

  def caveats; <<-EOS.undent
     Framework JSTalk was installed to:
       #{prefix}/Frameworks/JSTalk.framework

     You may want to symlink this Framework to a standard OS X location,
     such as:
       mkdir ~/Frameworks
       ln -s "#{prefix}/Frameworks/JSTalk.framework" ~/Frameworks

    JSTalk Editor.app was installed in:
      #{prefix}

    To symlink into ~/Applications, you can do:
      brew linkapps
    EOS
  end
end
