require 'formula'

class Gptsync < Formula
  homepage 'http://refit.sourceforge.net/'
  url 'http://downloads.sourceforge.net/refit/refit-src-0.14.tar.gz'
  sha1 'ea80a6517c1b0ce5c92c8a605a40309e2e5a9cc2'

  def install
    cd "gptsync" do
      system "make", "-f", "Makefile.unix", "CC=#{ENV.cc}"
      sbin.install 'gptsync', 'showpart'
      man8.install 'gptsync.8'
    end
  end
end
