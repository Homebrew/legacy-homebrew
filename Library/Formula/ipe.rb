class Ipe < Formula
  desc "Drawing editor for creating figures in PDF or PS formats"
  homepage "http://ipe.otfried.org/"
  url "https://github.com/otfried/ipe/raw/master/releases/7.1/ipe-7.1.8-src.tar.gz"
  sha256 "6a7b8dfb0a012ef9e96b62c317974d910ab6904bef29ae7636d5ac1cb26fa6ff"

  bottle do
    sha256 "67068ec329e946fd27356eafbbecd9448f5ac0781912a46a4e7baa939fa682dd" => :yosemite
    sha256 "fae4394322876c9610076164a48d37cc4bc15d7f7f369312241a86c3c3f2e28b" => :mavericks
    sha256 "6e786c07223ddfe324ea3e5581740f4b02d31b79ccf5c3e1340ab09e69e27a99" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "makeicns" => :build
  depends_on "lua"
  depends_on "qt"
  depends_on "cairo"
  depends_on "jpeg-turbo"
  depends_on "freetype"

  fails_with :clang do
    build 318
    cause <<-EOS.undent
      IPE should be compiled with the same flags as Qt, which uses LLVM.
      ipeui_common.cpp:1: error: bad value (native) for -march= switch
    EOS
  end

  def install
    # There's a weird race condition around setting flags for Freetype
    # If we ever go back to using flags instead of pkg-config be wary of that.
    ENV.deparallelize

    cd "src" do
      # Comment this out so we can make use of pkg-config.
      # Upstream have said they will *never* support OS X, so we have free reign.
      inreplace "config.mak" do |s|
        s.gsub! "ifndef MACOS", "ifdef MACOS"
        s.gsub! "moc-qt4", "moc"
      end

      system "make", "IPEPREFIX=#{HOMEBREW_PREFIX}"
      system "make", "IPEPREFIX=#{prefix}", "install"
    end
  end
end
