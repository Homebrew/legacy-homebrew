require 'formula'

class StyleCheck < Formula
  homepage 'http://www.cs.umd.edu/~nspring/software/style-check-readme.html'
  url 'http://www.cs.umd.edu/~nspring/software/style-check-0.14.tar.gz'
  sha1 '7308ba19fb05a84e2a8cad935b8056feba63d83b'

  def install
    inreplace "style-check.rb", '/etc/style-check.d/', etc+'style-check.d/'
    system "make", "PREFIX=#{prefix}",
                   "SYSCONFDIR=#{etc}/style-check.d",
                   "install"
  end
end
