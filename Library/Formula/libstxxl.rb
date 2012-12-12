require 'formula'

class Libstxxl < Formula
  homepage 'http://stxxl.sourceforge.net/'
  url 'http://sourceforge.net/projects/stxxl/files/stxxl/1.3.1/stxxl-1.3.1.tar.gz'
  sha1 '5fba2bb26b919a07e966b2f69ae29aa671892a7d'

  def install
    ENV['COMPILER'] = ENV.cxx

    system "make", "config_gnu", "USE_MACOSX=yes"
    system "make", "library_g++", "USE_MACOSX=yes"

    prefix.install 'include'
    lib.install 'lib/libstxxl.a'
  end
end
