require 'formula'

class Libstxxl < Formula
  homepage 'http://stxxl.sourceforge.net/'
  url 'http://sourceforge.net/projects/stxxl/files/stxxl/1.3.1/stxxl-1.3.1.tar.gz'
  md5 '8d0e8544c4c830cf9ae81c39b092438c'

  def install
    ENV['COMPILER'] = ENV.cxx

    system "make", "config_gnu", "USE_MACOSX=yes"
    system "make", "library_g++", "USE_MACOSX=yes"

    prefix.install Dir['include']
    lib.install 'lib/libstxxl.a'
  end
end
