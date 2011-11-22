require 'formula'

class Clucene < Formula
  url 'http://downloads.sourceforge.net/project/clucene/clucene-core-stable/0.9.21/clucene-core-0.9.21.tar.bz2'
  homepage 'http://sourceforge.net/projects/clucene/'
  md5 '181cf9a827fd072717d9b09d1a1bda74'
  head 'git://clucene.git.sourceforge.net/gitroot/clucene/clucene'

  def install
    if ARGV.build_head?
      system "cmake . #{std_cmake_parameters}"
    else
      system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    end

    # Install in parallel. See:
    # https://github.com/mxcl/homebrew/issues/8712
    ENV.j1
    system "make install"
  end
end
