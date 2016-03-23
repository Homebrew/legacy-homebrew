class Nesc < Formula
  desc "Programming language for deeply networked systems"
  homepage "https://github.com/tinyos/nesc"
  url "https://github.com/tinyos/nesc/archive/v1.3.6.tar.gz"
  sha256 "80a979aacda950c227542f2ddd0604c28f66fe31223c608b4f717e5f08fb0cbf"

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on :java => :build
  depends_on :emacs => :build

  bottle do
    cellar :any_skip_relocation
    sha256 "aa7e61956f6b0e505ff4ed31ecd53e1d9f007b062f0efc94d34485667525dabf" => :el_capitan
    sha256 "587202b38e19508979e0bf7ad05144cb1d82e27cbdde7bc626798947caeb1288" => :yosemite
    sha256 "e39de1a28a7459f5948826bb8533c4adf1e2efe76eb7230a1dd8de00eb625cb7" => :mavericks
  end

  def install
    # nesc is unable to build in parallel because multiple emacs instances
    # lead to locking on the same file
    ENV.deparallelize

    system "./Bootstrap"
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
