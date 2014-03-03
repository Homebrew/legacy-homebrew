require 'formula'

class Tnef < Formula
  homepage 'http://sourceforge.net/projects/tnef/'
  url 'https://downloads.sourceforge.net/project/tnef/tnef/tnef-1.4.10.tar.gz'
  sha1 'c765d3d197f051f46fbe004e1ec9065f69734366'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
