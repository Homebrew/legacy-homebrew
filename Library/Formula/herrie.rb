class Herrie < Formula
  desc "Minimalistic audio player built upon Ncurses"
  homepage "http://herrie.info/"
  url "http://herrie.info/distfiles/herrie-2.2.tar.bz2"
  sha256 "142341072920f86b6eb570b8f13bf5fd87c06cf801543dc7d1a819e39eb9fb2b"

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "libvorbis"
  depends_on "libid3tag"
  depends_on "mad"
  depends_on "libsndfile"

  def install
    ENV["PREFIX"] = prefix
    system "./configure", "no_modplug", "no_xspf", "coreaudio", "ncurses"
    system "make", "install"
  end

  test do
    system "#{bin}/herrie", "-v"
  end
end
