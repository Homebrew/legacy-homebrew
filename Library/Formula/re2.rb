require 'formula'

class Re2 < Formula
  homepage 'https://code.google.com/p/re2/'
  url 'https://re2.googlecode.com/files/re2-20130115.tgz'
  sha1 '71f1eac7fb83393faedc966fb9cdb5ba1057d85f'

  def install
    system "make", "install", "prefix=#{prefix}"
  end

end

