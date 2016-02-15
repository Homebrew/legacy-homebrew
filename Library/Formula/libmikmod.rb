class Libmikmod < Formula
  desc "Portable sound library"
  homepage "http://mikmod.shlomifish.org"
  url "https://downloads.sourceforge.net/project/mikmod/libmikmod/3.3.8/libmikmod-3.3.8.tar.gz"
  sha256 "4acf6634a477d8b95f18b55a3e2e76052c149e690d202484e8b0ac7589cf37a2"

  bottle do
    cellar :any
    sha256 "1c6f5b600d2910d383f63f4f8c0b2ff66f98993bf19973a9459d6c2bdb9acdb7" => :el_capitan
    sha256 "e2e4471fb83ce3b4f9507f83873a6e99650cc81683030eaef912017a9eadec1a" => :yosemite
    sha256 "5ecca18000c9e113385929e5618b644f81f33da059c0b280e22e55545d30825f" => :mavericks
  end

  option "with-debug", "Enable debugging symbols"
  option :universal

  def install
    ENV.O2 if build.with? "debug"
    ENV.universal_binary if build.universal?

    # OSX has CoreAudio, but ALSA is not for this OS nor is SAM9407 nor ULTRA.
    args = %W[
      --prefix=#{prefix}
      --disable-alsa
      --disable-sam9407
      --disable-ultra
    ]
    args << "--with-debug" if build.with? "debug"
    mkdir "macbuild" do
      system "../configure", *args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/libmikmod-config", "--version"
  end
end
