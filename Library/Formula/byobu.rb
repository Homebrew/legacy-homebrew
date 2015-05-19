class Byobu < Formula
  desc "Text-based window manager and terminal multiplexer"
  homepage "http://byobu.co"
  url "https://launchpad.net/byobu/trunk/5.92/+download/byobu_5.92.orig.tar.gz"
  sha256 "22a5cab37c2426688945a5dfebc521dc684a4eda11bf48a1767dc6ba4b2b7a2c"

  bottle do
    sha256 "00b83c52d088c2ac0b46ebe5f15fc07af5f9bed8d1687ddf3a9ff019cd2340bb" => :yosemite
    sha256 "8261afcff0043e4f3435e92facf03f686621400a18d9ff6c38b43a49c1d42789" => :mavericks
    sha256 "c73501b5d8969028206d6a3479b2556e4efbf9c24effaad973a96c6a35d68dcd" => :mountain_lion
  end

  depends_on "coreutils"
  depends_on "gnu-sed" # fails with BSD sed
  depends_on "tmux"
  depends_on "newt" => "with-python"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"byobu-status"
  end

  def caveats; <<-EOS.undent
    Add the following to your shell configuration file:
      export BYOBU_PREFIX=$(brew --prefix)
    EOS
  end
end
