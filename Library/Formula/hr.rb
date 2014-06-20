require 'formula'

class Hr < Formula
  homepage 'https://github.com/LuRsT/hr'
  url 'https://github.com/LuRsT/hr/archive/1.1.tar.gz'
  sha1 '72e0a7836fe5181205de816bb5e0d44be3a8961f'

  head 'https://github.com/LuRsT/hr', :branch => 'master'

  def install
    bin.install 'hr'
    man1.install 'hr.1'
  end

  test do
    system "#{bin}/hr", "-#-"
  end
end
