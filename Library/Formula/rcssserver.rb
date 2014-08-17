require "formula"

class Rcssserver < Formula
  homepage "http://sserver.sourceforge.net/"
  url "https://downloads.sourceforge.net/sserver/rcssserver/15.2.2/rcssserver-15.2.2.tar.gz"
  sha1 "43012eb5301716e457e93ec42c0c00727e600c84"

  bottle do
    cellar :any
    sha1 "72e049b25605887a54b941a388ad16bd50baad69" => :mavericks
    sha1 "9a398073a7e711b49ba39b2da09c0f7a29ed19af" => :mountain_lion
    sha1 "ab94f23eae47b48ce2f9ed3d94e727f2d7387289" => :lion
  end

  head do
    url "svn://svn.code.sf.net/p/sserver/code/rcss/trunk/rcssserver"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "flex" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"

  def install
    ENV.j1

    if build.head?
      # These inreplaces are artifacts of the upstream packaging process:
      # http://sourceforge.net/p/sserver/discussion/76439/thread/bd3ad6e4
      inreplace "src/Makefile.am" do |s|
        s.gsub! "coach_lang_parser.h", "coach_lang_parser.hpp"
        s.gsub! "player_command_parser.h", "player_command_parser.hpp"
      end

      inreplace "src/coach_lang_tok.lpp", "coach_lang_parser.h", "coach_lang_parser.hpp"
      inreplace "src/player_command_tok.lpp", "player_command_parser.h", "player_command_parser.hpp"

      system "./bootstrap"
    end

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/rcssserver help | head -1 | grep 'rcssserver-#{version}'"
  end
end
