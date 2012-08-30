require 'formula'

class Md5deep < Formula
  homepage 'http://md5deep.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/md5deep/md5deep/md5deep-4.2/md5deep-4.2.tar.gz'
  sha1 '9176081bfdfcd67e2e5261ed431d00ef5b7d9c17'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system("#{bin}/md5deep -h") && system("#{bin}/hashdeep -h")
  end
end
