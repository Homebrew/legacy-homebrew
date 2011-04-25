require 'formula'

class Objfw < Formula
  url 'https://webkeks.org/objfw/downloads/objfw-0.5.2.tar.gz'
  homepage 'https://webkeks.org/objfw/'
  md5 'c4302df7637c812344b7b2f531ccf7d1'

  def install
    system "xcodebuild -target ObjFW"
    system "mkdir -p #{prefix}/Library/Frameworks"
    system "cp -R Build/Release/ObjFW.framework #{prefix}/Library/Frameworks"
  end
end
