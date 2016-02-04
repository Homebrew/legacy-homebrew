class Rubberband < Formula
  desc "audio time stretcher tool and library"
  homepage "http://breakfastquay.com/rubberband/"
  head "https://bitbucket.org/breakfastquay/rubberband/", :using => :hg

  stable do
    url "http://code.breakfastquay.com/attachments/download/34/rubberband-1.8.1.tar.bz2"
    sha256 "ff0c63b0b5ce41f937a8a3bc560f27918c5fe0b90c6bc1cb70829b86ada82b75"
    # replace vecLib.h by Accelerate.h
    # already fixed in upstream:
    # https://bitbucket.org/breakfastquay/rubberband/commits/cb02b7ed1500f0c06c0ffd196921c812dbcf6888
    # https://bitbucket.org/breakfastquay/rubberband/commits/9e32f693c6122b656a0df63bc77e6a96d6ba213d
    patch :p1 do
      url "https://raw.githubusercontent.com/homebrew/patches/1fd51a983cf7728958659bab95073657b1801b3c/rubberband/rubberband-1.8.1-yosemite.diff"
      sha256 "7686dd9d05fddbcbdf4015071676ac37ecad5c7594cc06470440a18da17c71cd"
    end
  end
  bottle do
    cellar :any
    revision 1
    sha256 "ec6ec212a0173ba661601b2fb5ae1dace5dab1100688d3b5c9a460796eae705b" => :el_capitan
    sha256 "6a62c8da1d779672bf0ef276656b2dfa5edf885e704a875c606a27b9aea863fe" => :yosemite
    sha256 "5ca9579f1b84a3a843e5b52654f41b25e4c02fdc5df05a0966c6d8627843dac4" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "libsamplerate"
  depends_on "libsndfile"

  def install
    system "make", "-f", "Makefile.osx"
    bin.install "bin/rubberband"
    lib.install "lib/librubberband.dylib"
    include.install "rubberband"

    cp "rubberband.pc.in", "rubberband.pc"
    inreplace "rubberband.pc", "%PREFIX%", opt_prefix
    (lib/"pkgconfig").install "rubberband.pc"
  end

  test do
    assert_match /Pass 2: Processing.../, shell_output("rubberband -t2 #{test_fixtures("test.wav")} out.wav 2>&1")
  end
end
