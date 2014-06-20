require 'formula'

class Gsl < Formula
  homepage 'http://www.gnu.org/software/gsl/'
  url 'http://ftpmirror.gnu.org/gsl/gsl-1.16.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/gsl/gsl-1.16.tar.gz'
  sha1 '210af9366485f149140973700d90dc93a4b6213e'

  bottle do
    cellar :any
    sha1 "0ab78f7b7e7cfe8240183c03b4817159f42230b9" => :mavericks
    sha1 "e44a6b9517c137d8c1d3a5dadc629a9c20bc0787" => :mountain_lion
    sha1 "18ac0c4c9c827786e2ed77c9df2531a7f0f709a3" => :lion
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make" # A GNU tool which doesn't support just make install! Shameful!
    system "make install"
  end
end
