class Help2man < Formula
  desc "Automatically generate simple man pages"
  homepage "https://www.gnu.org/software/help2man/"
  url "http://ftpmirror.gnu.org/help2man/help2man-1.47.3.tar.xz"
  mirror "https://ftp.gnu.org/gnu/help2man/help2man-1.47.3.tar.xz"
  sha256 "c232af6475ef65bee02770862a362f4c4c2e6c9967d39e987eb94cadcfc13856"

  bottle do
    cellar :any_skip_relocation
    sha256 "4bb6faedcef5f7f902243b262fac4b8ecc700be779bb32a2b387a4a92046c047" => :el_capitan
    sha256 "a44b9866d1d24730fc09e9a7d9180bf5bca726f71b03e457812a5715dd3179b8" => :yosemite
    sha256 "2e14f7b80487ebac1c91c87684a0a4ae027208e115ad024bd3a2326dc8ddcd48" => :mavericks
  end

  def install
    # install is not parallel safe
    # see https://github.com/Homebrew/homebrew/issues/12609
    ENV.j1

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "help2man #{version}", shell_output("#{bin}/help2man #{bin}/help2man")
  end
end
