require 'formula'

class Libntlm < Formula
  homepage 'http://www.nongnu.org/libntlm/'
  url 'http://www.nongnu.org/libntlm/releases/libntlm-1.3.tar.gz'
  sha1 '5dd798d5fb9a75656225052aa88ceb9befbbd4a0'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
