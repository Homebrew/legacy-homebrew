class Sox < Formula
  desc "SOund eXchange: universal sound sample translator"
  homepage "http://sox.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/sox/sox/14.4.2/sox-14.4.2.tar.gz"
  sha256 "b45f598643ffbd8e363ff24d61166ccec4836fea6d3888881b8df53e3bb55f6c"

  depends_on "pkg-config" => :build
  depends_on "libpng"
  depends_on "mad"
  depends_on "opencore-amr" => :optional
  depends_on "opusfile" => :optional
  depends_on "libvorbis" => :optional
  depends_on "flac" => :optional
  depends_on "libsndfile" => :optional
  depends_on "libao" => :optional
  depends_on "lame" => :optional

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
