class Jpeg < Formula
  desc "JPEG image manipulation library"
  homepage "http://www.ijg.org"
  url "http://www.ijg.org/files/jpegsrc.v8d.tar.gz"
  sha256 "00029b1473f0f0ea72fbca3230e8cb25797fbb27e58ae2e46bb8bf5a806fe0b3"

  bottle do
    cellar :any
    revision 2
    sha1 "a0d4d16fcbee7ad6ef49f16bb55650291b877885" => :yosemite
    sha1 "f668b1e9cb382e194c632c1d5865b7bea096c3ac" => :mavericks
    sha1 "4dd056f2bf243eef145a613ed1a51e65e4b5d0a4" => :mountain_lion
    sha1 "396612e00ac31ca730d913ebdfd1b99881304702" => :lion
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/djpeg", test_fixtures("test.jpg")
  end
end
