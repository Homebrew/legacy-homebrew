require 'formula'

class Jstalk < Formula
  homepage 'http://jstalk.org/'
  url 'https://github.com/ccgus/jstalk/archive/v1.0.1.tar.gz'
  sha1 '9257333ca347bc29cfc5e97cc199b61cfefa2168'

  head 'https://github.com/ccgus/jstalk.git'

  depends_on :macos => :snow_leopard
  depends_on :xcode # For working xcodebuild.

  def install
    ["JSTalk Framework", "jstalk command line", "JSTalk Editor"].each do |t|
      system "xcodebuild", "-target", t, "-configuration", "Release", "ONLY_ACTIVE_ARCH=YES", "SYMROOT=build"
    end

    cd 'build/Release' do
      bin.install 'jstalk'
      prefix.install "JSTalk Editor.app"
      frameworks.install 'JSTalk.framework'
    end
  end

  def caveats; <<-EOS.undent
     Framework JSTalk was installed to:
       #{frameworks}/JSTalk.framework

     You may want to symlink this Framework to a standard OS X location,
     such as:
       mkdir ~/Frameworks
       ln -s "#{frameworks}/JSTalk.framework" ~/Frameworks

    JSTalk Editor.app was installed in:
      #{prefix}

    To symlink into ~/Applications, you can do:
      brew linkapps
    EOS
  end
end
