require 'formula'

class Md5sha1sum < Formula
  homepage 'http://www.microbrew.org/tools/md5sha1sum/'
  url 'http://www.microbrew.org/tools/md5sha1sum/md5sha1sum-0.9.5.tar.gz'
  sha1 '84a46bfd2b49daa0a601a9c55b7d87c27e19ef87'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    bin.install 'md5sum'
    bin.install_symlink bin/'md5sum' => 'sha1sum'
    bin.install_symlink bin/'md5sum' => 'ripemd160sum'
  end
end
