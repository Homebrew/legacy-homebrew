require 'formula'

class Jstalk < Formula
  homepage 'http://jstalk.org/'
  url 'https://github.com/ccgus/jstalk/archive/v1.0.1.tar.gz'
  sha1 '9257333ca347bc29cfc5e97cc199b61cfefa2168'

  head 'https://github.com/ccgus/jstalk.git'

  depends_on :macos => :snow_leopard
  depends_on :xcode

  def install
    ["JSTalk Framework", "jstalk command line", "JSTalk Editor"].each do |t|
      xcodebuild "-target", t, "-configuration", "Release", "ONLY_ACTIVE_ARCH=YES", "SYMROOT=build"
    end

    cd 'build/Release' do
      bin.install 'jstalk'
      prefix.install "JSTalk Editor.app"
      frameworks.install 'JSTalk.framework'
    end
  end
end
