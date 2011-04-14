require 'formula'

class Jstalk < Formula
  url 'git://github.com/ccgus/jstalk.git', :tag => "v1.0.1"
  homepage 'http://jstalk.org/'
  version '1.0.1'

  def install
    if MacOS.leopard?
      onoe "jstalk requires Mac OS X 10.6+"
      exit 1
    end

    # JSTalk specifies its particular compiler needs in jstalk.xcodeproj
    ENV.delete 'CC'
    ENV.delete 'CXX'

    args = ["-configuration", "Release", "ONLY_ACTIVE_ARCH=YES"]
    targets = ["JSTalk Framework", "jstalk command line", "JSTalk Editor"]

    targets.each do |target|
      system "xcodebuild", "-target", target, *args
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
