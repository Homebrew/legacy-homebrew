require 'formula'

class Bash < Formula
  url 'http://ftp.gnu.org/gnu/bash/bash-4.2.tar.gz'
  homepage 'http://www.gnu.org/software/bash/'
  sha1 '487840ab7134eb7901fbb2e49b0ee3d22de15cb8'
  version '4.2.7'

  depends_on 'readline'

  def patches
    patch_level = version.split('.').last.to_i
    {'p0' => (1..patch_level).map { |i| "http://ftp.gnu.org/gnu/bash/bash-4.2-patches/bash42-%03d" % i }}
  end


  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
