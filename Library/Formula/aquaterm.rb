require 'formula'
 
class Aquaterm <Formula
  url 'http://sourceforge.net/projects/aquaterm/files/AquaTerm/v1.0.1/aquaterm_src.1.0.1.tar.gz/download'
  homepage 'http://aquaterm.sourceforge.net/'
  md5 'e9d3ecdfe770d6f09a748add9886d1a9'
  version '1.0.1'
 
  def install
    # This build is untested for ppc and ppc64
    productVersion = `sw_vers -productVersion`[0,4]
    sdk = "-sdk macosx#{productVersion}"
    archs = []
    parch = `uname -p`.strip
    archs << parch
    if Hardware.is_64_bit? then
      case parch
        when /ppc/
          archs << 'ppc64'
        when /i386/
          archs << 'x86_64'
      end
    end
 
    system "cd aquaterm; xcodebuild -target AquaTerm #{sdk} ARCHS='#{archs.join(' ')}' MACOSX_DEPLOYMENT_TARGET=''"
 
    (prefix+'Applications').install(Dir['aquaterm/build/Default/AquaTerm.app'])
    (prefix+'Library/Frameworks').install(Dir['aquaterm/build/Default/AquaTerm.framework'])
 
    lib.mkpath()
    include.mkpath()
    aqFramework = (prefix+'Library/Frameworks/AquaTerm.framework/Versions/A')
    (lib+'libaquaterm.dylib').make_link aqFramework+'AquaTerm'
    (lib+'libaquaterm.1.0.0.dylib').make_link aqFramework+'AquaTerm'
    (include+'aquaterm').install Dir[aqFramework+'Headers/*']
  end
 
  def caveats
    <<-EOF
    Run the following commands if you would like AquaTerm residing next to other applications,
    and provide the AquaTerm framework to other applications that may require it, e.g. gnuplot.
 
    sudo ln -s #{prefix+'Applications'}/AquaTerm.app /Applications/
    sudo ln -s #{prefix+'Library/Frameworks'}/AquaTerm.framework /Library/Frameworks/
  EOF
  end
end
