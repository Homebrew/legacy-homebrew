require 'formula'

class Clucene < Formula
  homepage 'http://clucene.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/clucene/clucene-core-stable/0.9.21b/clucene-core-0.9.21b.tar.bz2'
  sha1 '8bc505b64f82723c2dc901036cb0607500870973'

  head do
    url 'git://clucene.git.sourceforge.net/gitroot/clucene/clucene'
    depends_on 'cmake' => :build
  end

  def patches
    p = []
    if MacOS.version >= :mavericks
      # fix libpthread dependencies in OS X 10.9
      {
        :p0 => ["http://trac.macports.org/export/112875/trunk/dports/devel/clucene/files/patch-src-shared-CLucene-LuceneThreads.h.diff",
          "http://trac.macports.org/export/112875/trunk/dports/devel/clucene/files/patch-src-shared-CLucene-config-repl_tchar.h.diff"]
      }
    end
    p
  end

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
