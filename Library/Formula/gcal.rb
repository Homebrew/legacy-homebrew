require 'formula'

class Gcal < Formula
  homepage 'http://www.gnu.org/software/gcal/'
  url 'http://ftpmirror.gnu.org/gcal/gcal-3.6.2.tar.xz'
  mirror 'http://ftp.gnu.org/gnu/gcal/gcal-3.6.2.tar.xz'
  sha1 '45dfa00e362d9c4ab8978a7a2f2ab898b156a3c4'

  depends_on 'xz' => :build

  def install
    system './configure', "--prefix=#{prefix}", '--disable-dependency-tracking'
    system "make install"
  end
end
