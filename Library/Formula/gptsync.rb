require 'formula'

class Gptsync < Formula
  homepage 'http://refit.sourceforge.net/'
  url 'http://downloads.sourceforge.net/refit/refit-src-0.14.tar.gz'
  md5 '16f02fa5b5decdee17eebd5cd863b3f0'

  def install
    cd "gptsync" do
      system "make", "-f", "Makefile.unix", "CC=#{ENV.cc}"
      sbin.install 'gptsync', 'showpart'
      man8.install 'gptsync.8'
    end
  end
end
