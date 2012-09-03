require 'formula'

class Clucene < Formula
  homepage 'http://clucene.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/clucene/clucene-core-stable/0.9.21/clucene-core-0.9.21.tar.bz2'
  sha1 'a614977097b64266b4207016e269c34b2217b0b2'

  head 'git://clucene.git.sourceforge.net/gitroot/clucene/clucene'

  def install
    if build.head?
      system "cmake", ".", *std_cmake_args
    else
      system "./configure", "--disable-debug", "--disable-dependency-tracking",
                            "--prefix=#{prefix}"
    end

    # Serialize the install step. See:
    # https://github.com/mxcl/homebrew/issues/8712
    ENV.j1
    system "make install"
  end
end
