class Imapfilter < Formula
  desc "IMAP message processor/filter"
  homepage "https://github.com/lefcha/imapfilter/"
  url "https://github.com/lefcha/imapfilter/archive/v2.6.1.tar.gz"
  sha256 "d9494a52083769687e780da41cf9a4d21beb56af5863afb3dbc4a2109ed5c1d3"

  bottle do
    sha256 "1fca23f569f7de19ccb72310af7cfba121143c7e4f751bbe7f59c7a5cfde606d" => :yosemite
    sha256 "4a897729189bcf0d8dffcbdd3c1cc12027f269aac5f3859e71387d3a53993a81" => :mavericks
    sha256 "4568d3a793d0b0f99fce9c7bcb4e766479d71a43c9a7d1e23f304ac42f35708c" => :mountain_lion
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
