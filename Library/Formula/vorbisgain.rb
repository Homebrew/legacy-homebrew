class Vorbisgain < Formula
  desc "Add Replay Gain volume tags to Ogg Vorbis files"
  homepage "http://sjeng.org/vorbisgain.html"
  url "http://sjeng.org/ftp/vorbis/vorbisgain-0.37.tar.gz"
  sha256 "dd6db051cad972bcac25d47b4a9e40e217bb548a1f16328eddbb4e66613530ec"

  depends_on "libvorbis"
  depends_on "libogg"

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end
end
