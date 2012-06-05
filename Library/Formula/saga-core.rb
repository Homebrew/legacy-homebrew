require 'formula'

class SagaCore < Formula
  homepage 'http://saga-project.org'
  url 'http://download.saga.cct.lsu.edu/saga-core/saga-core-1.6.tgz'
  md5 'a5cda84bdae1f96646f39fda0aa7db73'

  head 'https://svn.cct.lsu.edu/repos/saga/core/trunk/'

  depends_on 'boost'
  depends_on 'postgresql'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-boost=#{HOMEBREW_PREFIX}",
                          "--with-postgresql=#{HOMEBREW_PREFIX}"
    system "make install"
  end
end
