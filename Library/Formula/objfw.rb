require 'formula'

class Objfw < Formula
  url 'https://webkeks.org/objfw/downloads/objfw-0.5.3.tar.gz'
  homepage 'https://webkeks.org/objfw/'
  sha256 '9a5db85312086d69a08999347fe1fd3052c4b2f2cdbd146d849d263fdd74a798'

  def install
    system "xcodebuild -target ObjFW"
    system "mkdir -p #{prefix}/Library/Frameworks"
    system "cp -R Build/Release/ObjFW.framework #{prefix}/Library/Frameworks"
  end
end
