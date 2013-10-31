require 'formula'

class Vcprompt < Formula
  homepage 'https://bitbucket.org/gward/vcprompt'
  url 'https://bitbucket.org/gward/vcprompt/downloads/vcprompt-1.1.tar.gz'
  sha1 '6982e3ecc0c677546da1e067984c0e25c3f9261c'

  head 'hg://https://bitbucket.org/gward/vcprompt'

  def install
    system "make", "PREFIX=#{prefix}",
                   "MANDIR=#{man1}",
                   "install"
  end

  test do
    system "#{bin}/vcprompt"
  end
end
