require 'formula'

class SagaCore < Formula
  url 'http://download.saga.cct.lsu.edu/saga-core/saga-core-1.6.tgz'
  head 'https://svn.cct.lsu.edu/repos/saga/core/trunk/', :using => :svn
  homepage 'http://saga-project.org'
  md5 'a5cda84bdae1f96646f39fda0aa7db73'

  depends_on 'boost'
  depends_on 'postgresql'

  def install
    args = ["--prefix=#{prefix}",
            "--with-boost=#{HOMEBREW_PREFIX}",
            "--with-postgresql=#{HOMEBREW_PREFIX}"]

    system "./configure", *args
    system "make install"
  end
end
