require 'formula'

class Jstalk <Formula
  homepage 'http://jstalk.org'
  head 'git://github.com/ccgus/jstalk.git'
  url 'http://jstalk.org/download/JSTalkPreview.zip'
  version '1.0b'
  md5 '405ffbb0f37b8244461b3872cc8d76fa'

  def install

    if ARGV.build_head?
      ENV.delete 'CC'
      ENV.delete 'CXX'

      args = ["-configuration", "Release", "ONLY_ACTIVE_ARCH=YES"]
      targets = ["JSTalk Framework", "jstalk command line", "JSTalk Editor"]

      targets.each do |target|
        # Workaround
        # http://jstalk.lighthouseapp.com/projects/26692-jstalk/tickets/25
        args << "CC=/usr/bin/clang" if target == "JSTalk Editor"
        system "xcodebuild", "-target", target, *args
      end

      cd 'build/Release' do
        bin.install 'jstalk'
        prefix.install "JSTalk Editor.app"
        prefix.install "JSTalk.framework"
      end

    else
      bin.install 'jstalk'
      prefix.install Dir['*']
    end

    cd prefix do
      mkdir 'Frameworks'; mv 'JSTalk.framework', 'Frameworks'
    end
  end

   def caveats
     framework_caveats = <<-EOS.undent
       Framework JSTalk was installed to:
         #{prefix}/Frameworks/JSTalk.framework

       You may want to symlink this Framework to a standard OS X location,
       such as:
         mkdir ~/Frameworks
         ln -s "#{prefix}/Frameworks/JSTalk.framework" ~/Frameworks

     EOS

     general_caveats = <<-EOS.undent
      JSTalk Editor.app was installed in:
        #{prefix}

      To symlink into ~/Applications, you can do:
        brew linkapps

    EOS

    return general_caveats + framework_caveats
  end

end
