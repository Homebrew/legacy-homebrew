class Imapfilter < Formula
  desc "IMAP message processor/filter"
  homepage "https://github.com/lefcha/imapfilter/"
  url "https://github.com/lefcha/imapfilter/archive/v2.6.5.tar.gz"
  sha256 "0f4b49e1be75ebfd5e3a3bdbff01d68aaafdb7acddc35fc40dcf437029708055"

  bottle do
    sha256 "2e28a6d04591cd54e0287f1d98487a10d613cd3ac55cc72657ddc9c3dbb95a80" => :el_capitan
    sha256 "0f35fc488ba1e743aa2f1f4e174679b0db1665f79a502f619c5a3b81b7896ee1" => :yosemite
    sha256 "e6e262409f8377a23c6b636b60f4269d6f75f02268afa5b2ac8cd9dc52a80606" => :mavericks
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
