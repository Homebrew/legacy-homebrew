class Rcssserver < Formula
  desc "Server for RoboCup Soccer Simulator"
  homepage "http://sserver.sourceforge.net/"
  url "https://downloads.sourceforge.net/sserver/rcssserver/15.2.2/rcssserver-15.2.2.tar.gz"
  sha256 "329b3008689dac16d1f39ad8f5c8341aef283ef3750d137dcf299d1fbc30355a"
  revision 1

  bottle do
    revision 2
    sha256 "979098bc6a12cfd6259e7d04dc46d56e066c1886d96e4d10900a151e8b635dd5" => :yosemite
    sha256 "1658febeae0a35d422acc63cd8fef1282fd81811a3f2742d8b34000c5fc8ab07" => :mavericks
    sha256 "a2560cd1527389c7312d71bede3ccd09eb6e037f42ceb79c41e9a030ed3b6b7e" => :mountain_lion
  end

  stable do
    resource "rcssmonitor" do
      url "https://downloads.sourceforge.net/sserver/rcssmonitor/15.1.1/rcssmonitor-15.1.1.tar.gz"
      sha256 "51f85f65cd147f5a9018a6a2af117fc45358eb2989399343eaadd09f2184ee41"
    end

    resource "rcsslogplayer" do
      url "https://downloads.sourceforge.net/sserver/rcsslogplayer/15.1.1/rcsslogplayer-15.1.1.tar.gz"
      sha256 "216473a9300e0733f66054345b8ea0afc50ce922341ac48eb5ef03d09bb740e6"
    end
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

    resources.each do |r|
      r.stage do
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
