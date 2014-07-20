require 'formula'

class Clucene < Formula
  homepage 'http://clucene.sourceforge.net'

  stable do
    url "https://downloads.sourceforge.net/project/clucene/clucene-core-stable/0.9.21b/clucene-core-0.9.21b.tar.bz2"
    sha1 "8bc505b64f82723c2dc901036cb0607500870973"

    # Fix libpthread dependencies in OS X 10.9 & 10.10
    # Based on MacPorts patches: http://trac.macports.org/ticket/40899
    # Reported upstream: http://sourceforge.net/p/clucene/bugs/219/
    if MacOS.version >= :mavericks
      patch :p0 do
        url "https://gist.githubusercontent.com/tlvince/7934499/raw/d0859996dbda8f4cf643d091ae6b491f0a64da59/CLucene-LuceneThreads.h.diff"
        sha1 "59e672e70d053d79d5b19c422945299ba66f2562"
      end

      patch :p0 do
        url "https://gist.githubusercontent.com/tlvince/7935339/raw/fd78b1ada278eaf1904e1437efa0f2a1265041a9/CLucene-config-repl_tchar.h.diff"
        sha1 "e6aee206577fc3b751652db6774d32e923b50b0b"
      end
    end
  end

  bottle do
    cellar :any
    sha1 "841fa0c1c9db0878423f658e59d90a98b290a24c" => :mavericks
    sha1 "96833aa75e8730eff1b0bb5fe4ca04c77642be4c" => :mountain_lion
    sha1 "88786dc87fca239143277d634d9c0c979cd10f18" => :lion
  end

  head do
    url "git://clucene.git.sourceforge.net/gitroot/clucene/clucene"

    depends_on "cmake" => :build

    patch do
      url "https://gist.githubusercontent.com/lfranchi/7954811/raw/828176c01a8f2c1c11eff43bf6773242955dabab/CLucene-HEAD-mavericks.patch"
      sha1 "43f89924e85f9df50bf32032f05de153237162f3"
    end if MacOS.version == :mavericks
  end

  def install
    if build.head?
      system "cmake", ".", *std_cmake_args
    else
      system "./configure", "--disable-debug", "--disable-dependency-tracking",
                            "--prefix=#{prefix}"
    end

    # Serialize the install step. See:
    # https://github.com/Homebrew/homebrew/issues/8712
    ENV.j1
    system "make install"
  end
end
