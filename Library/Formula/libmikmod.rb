class Libmikmod < Formula
  desc "Portable sound library"
  homepage "http://mikmod.shlomifish.org"
  url "https://downloads.sourceforge.net/project/mikmod/libmikmod/3.3.7/libmikmod-3.3.7.tar.gz"
  sha256 "4cf41040a9af99cb960580210ba900c0a519f73ab97b503c780e82428b9bd9a2"

  bottle do
    cellar :any
    revision 1
    sha1 "7c2b02e0af8bd35ef16963234062f386a6afbaac" => :yosemite
    sha1 "d3257de6616b399d3009f709cfb25e4f0b872025" => :mavericks
    sha1 "9384df42ef0e74aa4f077d8a85fc028f4ec9092a" => :mountain_lion
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
      system "make", "install"
    end
  end

  test do
    system "#{bin}/libmikmod-config", "--version"
  end
end
