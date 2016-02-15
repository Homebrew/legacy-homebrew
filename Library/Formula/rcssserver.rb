class Rcssserver < Formula
  desc "Server for RoboCup Soccer Simulator"
  homepage "http://sserver.sourceforge.net/"
  revision 3

  stable do
    url "https://downloads.sourceforge.net/sserver/rcssserver/15.2.2/rcssserver-15.2.2.tar.gz"
    sha256 "329b3008689dac16d1f39ad8f5c8341aef283ef3750d137dcf299d1fbc30355a"

    resource "rcssmonitor" do
      url "https://downloads.sourceforge.net/sserver/rcssmonitor/15.1.1/rcssmonitor-15.1.1.tar.gz"
      sha256 "51f85f65cd147f5a9018a6a2af117fc45358eb2989399343eaadd09f2184ee41"
    end

    resource "rcsslogplayer" do
      url "https://downloads.sourceforge.net/sserver/rcsslogplayer/15.1.1/rcsslogplayer-15.1.1.tar.gz"
      sha256 "216473a9300e0733f66054345b8ea0afc50ce922341ac48eb5ef03d09bb740e6"
    end
  end

  bottle do
    sha256 "c38e5393d6d4c9074d2c70da05e0be9f61bc2f935848a3e2061a93f2b002e9af" => :el_capitan
    sha256 "d7db1cd2a729f558cbb3569e1c858f9de8b6ced18b8eaf110b8db53881ad8c84" => :yosemite
    sha256 "053199b5e554e73a385ffd7de6ef8bf9e04b1c3876e6fed0b9ca1c98066364a1" => :mavericks
  end

  head do
    url "svn://svn.code.sf.net/p/sserver/code/rcss/trunk/rcssserver"

    resource "rcssmonitor" do
      url "svn://svn.code.sf.net/p/sserver/code/rcss/trunk/rcssmonitor_qt4"
    end

    resource "rcsslogplayer" do
      url "svn://svn.code.sf.net/p/sserver/code/rcss/trunk/rcsslogplayer"
    end

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "flex" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "qt"

  def install
    ENV.j1

    if build.head?
      # These inreplaces are artifacts of the upstream packaging process:
      # https://sourceforge.net/p/sserver/discussion/76439/thread/bd3ad6e4
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

    resources.each do |r|
      r.stage do
        # This line being glued together means unrelated libraries
        # are joined and cause a fatal linking error build compile.
        # -framework Security-ldbus-1 -lz -ldbus-1
        # ld: framework not found Security-ldbus-1
        # Currently same error in both rcssmonitor & rcsslogplayer.
        # https://sourceforge.net/p/sserver/mailman/message/34765272/
        inreplace "configure", "$QT4_REQUIRED_MODULES)$($PKG_CONFIG",
                               "$QT4_REQUIRED_MODULES) $($PKG_CONFIG"

        system "./bootstrap" if build.head?
        system "./configure", "--prefix=#{prefix}"
        system "make", "install"
      end
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rcssserver help", 1)
  end
end
