require 'formula'

class Skim <Formula
  head 'http://skim-app.svn.sourceforge.net/svnroot/skim-app/trunk'
  homepage 'http://skim-app.sourceforge.net/'

  def install
    system "xcodebuild SYMROOT=build"
    prefix.install "build/Release/Skim.app"
  end

   def caveats; <<-EOS
      Skim.app was installed in:
        #{prefix}

      To symlink into ~/Applications, you can do:
        brew linkapps
    EOS
  end
end
