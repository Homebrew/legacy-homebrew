require 'formula'

class Hr < Formula
  homepage 'https://github.com/LuRsT/hr'
  url 'https://github.com/LuRsT/hr/archive/1.0.tar.gz'
  sha1 '64abbc75d4e6cedd8ea4e15396e473298fc5240b'

  head 'https://github.com/LuRsT/hr', :branch => 'master'

  def install
    bin.install 'hr'
  end

  test do
    system "#{bin}/hr", "-#-"
  end
end
