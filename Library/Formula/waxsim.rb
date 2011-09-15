require 'formula'

class Waxsim < Formula
  url 'https://github.com/probablycorey/WaxSim/tarball/a694549be56f19095e6c342ed7867cd677df4137'
  homepage 'https://github.com/probablycorey/WaxSim'
  md5 '7edf2083878bbbf5982996fb77df018b'

  def install
    # Disable RunScript which copies binary off to some directories you don't have
    inreplace 'Waxsim.xcodeproj/project.pbxproj', 'shellPath = /bin/sh', 'shellPath = /usr/bin/true'

    system 'xcodebuild', '-configuration', 'Release', 'SYMROOT=build'
    bin.install 'build/Release/waxsim'
  end
end
