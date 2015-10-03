class Help2man < Formula
  desc "Automatically generate simple man pages"
  homepage "https://www.gnu.org/software/help2man/"
  url "http://ftpmirror.gnu.org/help2man/help2man-1.47.2.tar.xz"
  mirror "https://ftp.gnu.org/gnu/help2man/help2man-1.47.2.tar.xz"
  sha256 "c4c5606773e51039a06b7328ed4934913df142747a9a185d2a6ab9300d7f3f7c"

  bottle do
    cellar :any_skip_relocation
    sha256 "962ce7eabda523ee3b32f5a39454047cdac977497319542b359824df448eb8c7" => :el_capitan
    sha256 "304c8d51d8a237bd6879c32459ad4a77580f82acb178046c746ecf2c3f525329" => :yosemite
    sha256 "09487e392523fbe41fafe204311e33567ef52897edccc1070da17f5d652c7b51" => :mavericks
  end

  def install
    # install is not parallel safe
    # see https://github.com/Homebrew/homebrew/issues/12609
    ENV.j1

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    cmd = "#{bin}/help2man #{bin}/help2man"
    assert_match(/"help2man #{version}"/, shell_output(cmd))
  end
end
