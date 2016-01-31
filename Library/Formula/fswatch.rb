class Fswatch < Formula
  desc "Monitor a directory for changes and run a shell command"
  homepage "https://github.com/emcrisostomo/fswatch"
  url "https://github.com/emcrisostomo/fswatch/releases/download/1.8.0/fswatch-1.8.0.tar.gz"
  sha256 "0d4c4f1ad1ef7c3d783bf02ac018447ae77468337082ec90023a7319ed01aa78"

  bottle do
    cellar :any
    sha256 "3a540a746c4365f8612b900947bcd9b03bf9983b68c7338a0330b3e3071fc287" => :el_capitan
    sha256 "0ba0ba279855ff12376a1bf91e0825bcec109edf151336d161ce1abe329d32e7" => :yosemite
    sha256 "d8158b1e049e67a2f23ec31e2f509405fb6585b4da669d448c41dc9c7c06fb9d" => :mavericks
  end

  needs :cxx11

  def install
    ENV.cxx11
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make", "install"
  end
end
