class Imapfilter < Formula
  desc "IMAP message processor/filter"
  homepage "https://github.com/lefcha/imapfilter/"
  url "https://github.com/lefcha/imapfilter/archive/v2.6.3.tar.gz"
  sha256 "1174862d6d5ca498b25a78b127c25b6bfbd4c0cec30f8dfd4b6b10f8694cd244"

  bottle do
    sha256 "faef673eeae6b716575c440240b521da3468f99ae7d7ab9d6a12d0c2b453c7fc" => :yosemite
    sha256 "5647510f31a23f04aa46b15eb7998073e5f4274a29edd941d4cd759341a8e508" => :mavericks
    sha256 "ef25b37c894e52f0a6f7a21bb71b8f297bd32662bb08c74126d97a17a976fad2" => :mountain_lion
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
