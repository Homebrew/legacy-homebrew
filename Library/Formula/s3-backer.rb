require 'formula'

class S3Backer < Formula
  url 'http://s3backer.googlecode.com/files/s3backer-1.3.2.tar.gz'
  homepage 'http://code.google.com/p/s3backer/'
  sha1 'badc003ffb0830a3fa59c9f39f13ad94729cbcf1'

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
