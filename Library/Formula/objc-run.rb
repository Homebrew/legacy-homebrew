require 'formula'

class ObjcRun < Formula
  homepage 'https://github.com/iljaiwas/objc-run'
  url 'https://github.com/iljaiwas/objc-run/archive/1.4.tar.gz'
  sha1 '86c15705359f2dc2c62d70e358caf63c2a468fee'
  head 'https://github.com/iljaiwas/objc-run.git'

  def install
    bin.install 'objc-run'
    (share+'objc-run').install 'examples', 'test.bash'
  end

  test do
    system "#{share}/objc-run/test.bash"
  end
end
