class Imapfilter < Formula
  desc "IMAP message processor/filter"
  homepage "https://github.com/lefcha/imapfilter/"
  url "https://github.com/lefcha/imapfilter/archive/v2.6.4.tar.gz"
  sha256 "ab29faab15a5b9ac616bfca65114c5067a3a26b7b32e2a70c32eb12ac1f16c1e"

  bottle do
    sha256 "2959621359c147281707769fdb431d42d3421cf2cab2dc68b0c452eb010b3501" => :el_capitan
    sha256 "e1f6302ae6df4d67e4d61d877563fb96ccc1f05d2636dcc66f126c363336fcca" => :yosemite
    sha256 "223579b0481db3f89ecd3f97998a0b9ca74420520466c16a522f8eb1f7d6a59e" => :mavericks
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
