require 'formula'

class Md5sha1sum < Formula
  homepage 'http://www.microbrew.org/tools/md5sha1sum/'
  url 'http://www.microbrew.org/tools/md5sha1sum/md5sha1sum-0.9.5.tar.gz'
  md5 'a75c5e21071ffa66fad1001de040517a'

  def install
    system "./configure --prefix=#{prefix}"
    system "make"
    bin.install 'md5sum'
    bin.install_symlink bin/'md5sum' => 'sha1sum'
    bin.install_symlink bin/'md5sum' => 'ripemd160sum'
  end
end
