require 'formula'

class Libcouchbase < Formula
  url 'http://packages.couchbase.com/clients/c/libcouchbase-1.0.2.tar.gz'
  homepage 'http://couchbase.com/develop/c/current'
  md5 '1f2c80bcf3959175aa985cf7fa73ac2e'

  depends_on 'libevent'
  depends_on 'libvbucket'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
      "--prefix=#{prefix}", "--disable-couchbasemock"
    system "make install"
  end

  def test
    # check if it returns code is zero
    system "#{bin}/cbc-version"
  end
end
