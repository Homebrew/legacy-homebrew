require 'formula'

class Paperkey < Formula
  homepage 'http://www.jabberwocky.com/software/paperkey/'
  url 'http://www.jabberwocky.com/software/paperkey/paperkey-1.3.tar.gz'
  sha1 '16af56d0e7bdf081d60c59ea4d72e7df6d9cec21'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make check"
    system "make install"
  end
end
