class Imapfilter < Formula
  desc "IMAP message processor/filter"
  homepage "https://github.com/lefcha/imapfilter/"
  url "https://github.com/lefcha/imapfilter/archive/v2.6.4.tar.gz"
  sha256 "ab29faab15a5b9ac616bfca65114c5067a3a26b7b32e2a70c32eb12ac1f16c1e"

  bottle do
    sha256 "69a5c8c331a20e7c9bdc4ff32ff7deadee1b0ef8960eafe5a7e2da7be7ead831" => :el_capitan
    sha256 "cb366a1071b07551e8c1a5775bec6e8baaed0073655caa4d4bcf0fd68123fbf3" => :yosemite
    sha256 "b57f3f946564b137feeb1f51efb826424d5b1f68de29de86d2efac4fbcf98271" => :mavericks
  end

  depends_on "lua"
  depends_on "pcre"
  depends_on "openssl"

  def install
    inreplace "src/Makefile" do |s|
      s.change_make_var! "CFLAGS", "#{s.get_make_var "CFLAGS"} #{ENV.cflags}"
    end

    # find Homebrew's libpcre and lua
    ENV.append "LDFLAGS", "-L#{HOMEBREW_PREFIX}/lib"
    ENV.append "LDFLAGS", "-liconv"
    system "make", "PREFIX=#{prefix}", "MANDIR=#{man}", "LDFLAGS=#{ENV.ldflags}"
    system "make", "PREFIX=#{prefix}", "MANDIR=#{man}", "install"

    prefix.install "samples"
  end

  def caveats; <<-EOS.undent
    You will need to create a ~/.imapfilter/config.lua file.
    Samples can be found in:
      #{prefix}/samples
    EOS
  end

  test do
    system "#{bin}/imapfilter", "-V"
  end
end
