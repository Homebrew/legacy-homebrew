require 'formula'

class Clucene < Formula
  homepage 'http://clucene.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/clucene/clucene-core-stable/0.9.21b/clucene-core-0.9.21b.tar.bz2'
  sha1 '8bc505b64f82723c2dc901036cb0607500870973'

  head 'git://clucene.git.sourceforge.net/gitroot/clucene/clucene'

  depends_on 'cmake' => :build if build.head?

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
