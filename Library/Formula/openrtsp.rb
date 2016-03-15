class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2016.03.14.tar.gz"
  sha256 "67574112d881ce7729faa844d987b04dbc71dee88d1a811dc6499155f194683b"

  bottle do
    cellar :any_skip_relocation
    sha256 "49c9594da046dfef7005a6e56b66ce5d7ca7075b6d26865c7d5be9a0e2a0c8f5" => :el_capitan
    sha256 "55c86ff5826840c9fdb00495d89a290d0fb99689b7cd45ea0bb7cb4cd836e304" => :yosemite
    sha256 "bf8ecebfae81a65b78bb72d17606dad99b59da3ca04b84575141d64651b93c6c" => :mavericks
  end

  option "32-bit"

  def install
    if build.build_32_bit? || !MacOS.prefer_64_bit?
      ENV.m32
      system "./genMakefiles", "macosx-32bit"
    else
      system "./genMakefiles", "macosx"
    end

    system "make", "PREFIX=#{prefix}", "install"

    # Move the testing executables out of the main PATH
    libexec.install Dir.glob(bin/"test*")
  end

  def caveats; <<-EOS.undent
    Testing executables have been placed in:
      #{libexec}
    EOS
  end
end
