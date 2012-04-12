require 'formula'

class StyleCheck < Formula
  homepage 'http://www.cs.umd.edu/~nspring/software/style-check-readme.html'
  url 'http://www.cs.umd.edu/~nspring/software/style-check-0.14.tar.gz'
  md5 'b88b0632b80abf9c8aaa2c5f2c3e2934'

  def install
    inreplace "style-check.rb", '/etc/style-check.d/', etc+'style-check.d/'
    system "make", "PREFIX=#{prefix}",
                   "SYSCONFDIR=#{etc}/style-check.d",
                   "install"
  end
end
