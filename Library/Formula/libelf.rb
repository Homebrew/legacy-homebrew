require 'formula'

class Libelf < Formula
  homepage 'http://www.mr511.de/software/english.html'
  url 'http://www.mr511.de/software/libelf-0.8.13.tar.gz'
  md5 '4136d7b4c04df68b686570afa26988ac'

  def install
    system './configure', "--prefix=#{prefix}",
                          '--disable-debug',
                          '--disable-dependency-tracking'
    system 'make'  # Fails with clang-3.1.318 unless separate make steps.
    system 'make install'
  end
end
