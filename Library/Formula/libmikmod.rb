require "formula"

class Libmikmod < Formula
  homepage "http://mikmod.shlomifish.org"
  url "https://downloads.sourceforge.net/project/mikmod/libmikmod/3.3.7/libmikmod-3.3.7.tar.gz"
  sha256 "4cf41040a9af99cb960580210ba900c0a519f73ab97b503c780e82428b9bd9a2"

  bottle do
    cellar :any
    sha1 "eb5b851f5ceddf5c5cf95dff87570b3ba17534ec" => :mavericks
    sha1 "8f93de789fdca344d196458f65f4a444f59b8f0b" => :mountain_lion
    sha1 "70b74f60052e4bd590e2591c78ac8a123cb2b67f" => :lion
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
