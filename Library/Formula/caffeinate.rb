require 'formula'

class Caffeinate < Formula
  url 'git://github.com/uasi/caffeinate.git', :tag => 'f6fca5076c2e09a0fd6863fff3f51f2d80beabab'
  homepage 'https://github.com/uasi/caffeinate'
  md5 'c16adae4e018b98f57ca3898907bdd30'
  version '1.0'

  def install
    system "xcodebuild"
    cd 'build/Release' do
      bin.install 'caffeinate'
    end
  end
end
