require 'formula'

class Gsutil < Formula
  url 'http://gsutil.googlecode.com/files/gsutil_09-06-2011.tar.gz'
  homepage 'http://code.google.com/p/gsutil/'
  md5 'cbb5f16e50bc72df0d9aefa4ebdd08db'
  version '09-06-2011'

  def install
    libexec.install Dir["*"]
    bin.mkpath
    ln_s libexec+'gsutil', bin+'gsutil'
  end

  def test
    system "#{bin}/gsutil"
  end

end
