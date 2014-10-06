require "formula"

class Libmikmod < Formula
  homepage "http://mikmod.shlomifish.org"
  url "https://downloads.sourceforge.net/project/mikmod/libmikmod/3.3.7/libmikmod-3.3.7.tar.gz"
  sha256 "4cf41040a9af99cb960580210ba900c0a519f73ab97b503c780e82428b9bd9a2"

  bottle do
    cellar :any
    sha1 "b121b9a927481db6d3e94bd79516c0efb544869f" => :mavericks
    sha1 "f11f9c4d4bf8c518e137c372520e195e690d38c6" => :mountain_lion
    sha1 "6adc1665665bc50eac027d60668f5eb06ec89b91" => :lion
  end

  option "with-debug", "Enable debugging symbols"

  def install
    ENV.O2 if build.with? "debug"

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
      system "make install"
    end
  end

  test do
    system "#{bin}/libmikmod-config", "--version"
  end
end
