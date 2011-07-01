require 'formula'

class Md5sha1sum < Formula
  url 'http://www.microbrew.org/tools/md5sha1sum/md5sha1sum-0.9.5.tar.gz'
  homepage 'http://www.microbrew.org/tools/md5sha1sum/'
  md5 'a75c5e21071ffa66fad1001de040517a'

  def install
    system "./configure"
    system "make"
    bin.install "md5sum"
    ['sha1sum', 'ripemd160sum'].each { |s| ln_s bin+'md5sum', bin+s }
  end
end
