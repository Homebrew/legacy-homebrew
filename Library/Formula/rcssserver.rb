require "formula"

class Rcssserver < Formula
  homepage "http://sserver.sourceforge.net/"
  url "https://downloads.sourceforge.net/sserver/rcssserver/15.2.2/rcssserver-15.2.2.tar.gz"
  sha1 "43012eb5301716e457e93ec42c0c00727e600c84"

  bottle do
    revision 1
    sha1 "56c32d383b277e5fe7ac2eff20901bf0125824a2" => :mavericks
    sha1 "e6c7d2632a3d85c373046c77a4a77c5cc7979781" => :mountain_lion
    sha1 "0e3d146890d129fdc82b4aed4b36db9b9ae664b0" => :lion
  end

  stable do
    resource "rcssmonitor" do
      url "https://downloads.sourceforge.net/sserver/rcssmonitor/15.1.1/rcssmonitor-15.1.1.tar.gz"
      sha1 "60483838a81acd8ada6d228a86e54faeb019ab10"
    end

    resource "rcsslogplayer" do
      url "https://downloads.sourceforge.net/sserver/rcsslogplayer/15.1.1/rcsslogplayer-15.1.1.tar.gz"
      sha1 "d0b8f8e8a4328398655140e7c019149ab8d9c1c3"
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
    system "#{bin}/rcssserver help | head -1 | grep 'rcssserver-#{version}'"
    system "#{bin}/rcsslogplayer --version | tail -1 | grep 'rcsslogplayer Version'"
    system "#{bin}/rcssmonitor --version | tail -1 | grep 'rcssmonitor Version'"
  end
end
