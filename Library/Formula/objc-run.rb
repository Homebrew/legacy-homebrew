require 'formula'

class ObjcRun < Formula
  homepage 'https://github.com/iljaiwas/objc-run'
  url 'https://github.com/iljaiwas/objc-run/archive/1.0.tar.gz'
  sha1 "1fcdc44582b608988614e2e96dd5e760d02e8c98"
  head 'https://github.com/iljaiwas/objc-run.git'

  def install
    bin.install 'objc-run'
  end

  test do
    system 'which objc-run'
  end
end
