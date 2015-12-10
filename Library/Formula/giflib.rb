# Please check & build every `brew uses giflib` locally prior to
# submitting 5.x.x. Many formulae requiring giflib haven't
# updated to use 5.x.x yet.
# Can `brew install homebrew/versions/giflib5` for now.
class Giflib < Formula
  desc "A library and utilities for processing GIFs"
  homepage "http://giflib.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/giflib/giflib-5.1.1.tar.bz2"
  sha256 "391014aceb21c8b489dc7b0d0b6a917c4e32cc014ce2426d47ca376d02fe2ffc"

  bottle do
    cellar :any
    revision 1
    sha256 "2abbeb99b0dec772fa020ec4cecd0df512813a223ab3e32bc760180367af4138" => :el_capitan
    sha256 "3180706f4a94e7ede8c66299474ada34165b2947c262316186e424b1b9d25aba" => :yosemite
    sha256 "74316a4dd9b94ca052b6f784c9764764d0b24dd8dc1f3f29b5681a374989979a" => :mavericks
    sha256 "76953a4ac103ff0931f2e4f70dafe9283c9289de2dda7f800e8ca3b47b6830db" => :mountain_lion
  end

  option :universal

  depends_on :x11 => :optional

  def install
    ENV.universal_binary if build.universal?

    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
    ]

    if build.without? "x11"
      args << "--disable-x11" << "--without-x"
    else
      args << "--with-x" << "--enable-x11"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match /Screen Size - Width = 1, Height = 1/, shell_output("#{bin}/giftext #{test_fixtures("test.gif")}")
  end
end
