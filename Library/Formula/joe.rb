class Joe < Formula
  desc "Joe's Own Editor (JOE)"
  homepage "http://joe-editor.sourceforge.net/index.html"
  url "https://downloads.sourceforge.net/project/joe-editor/JOE%20sources/joe-4.0/joe-4.0.tar.gz"
  sha256 "c556adff77fd97bf1b86198de6cb82e0b92cda18579c4fef6c83b608d2ed2915"

  bottle do
    sha256 "26d743b8a2a4d5774b6bf6f205b6b30dd8fe44411f894d0bd7d6d09acad615e5" => :el_capitan
    sha256 "d6739911e38e9017999136d04c9b852110f2d625cd6048188d2618f072aaec0b" => :yosemite
    sha256 "4a7b57c3bf747ba2814f18a5f0b2a53ef005c0686b8c7c9650db67961cf384f8" => :mavericks
    sha256 "d7b0e974e3c23620df690dbbde753f87008112981b26c3166ea845d29d28a81e" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/stringify"
  end
end
