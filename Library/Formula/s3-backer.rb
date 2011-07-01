require 'formula'

class S3Backer < Formula
  url 'http://s3backer.googlecode.com/files/s3backer-1.3.1.tar.gz'
  homepage 'http://code.google.com/p/s3backer/'
  md5 '98907b98424c867a6e52ffdfbbdafce4'

  depends_on 'pkg-config' => :build

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end

  def caveats
    <<-EOS.undent
    This depends on the MacFUSE installation from http://code.google.com/p/macfuse/
    MacFUSE must be installed prior to installing this formula.
    EOS
  end
end
