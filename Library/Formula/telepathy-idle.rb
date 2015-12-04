class TelepathyIdle < Formula
  desc "Telepathy IRC connection manager"
  homepage "http://telepathy.freedesktop.org/wiki/Components/"
  url "http://telepathy.freedesktop.org/releases/telepathy-idle/telepathy-idle-0.2.0.tar.gz"
  sha256 "3013ad4b38d14ee630b8cc8ada5e95ccaa849b9a6fe15d2eaf6d0717d76f2fab"

  bottle do
    sha256 "01feaaaa1e88ec062a0ebe668a87455113d216aca2c86530f70b2ad6c4f7a589" => :mavericks
    sha256 "60eb98b2e728fba1813df62c5852efd30c1ab9b098ce5970f1af50c876af38e9" => :mountain_lion
    sha256 "a8c499da5e1b4f13e3545890223544ceb59c85e7f3665677b9d4e21d49d42c57" => :lion
  end

  depends_on "pkg-config" => :build
  depends_on "telepathy-glib"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-debug
      --disable-dependency-tracking
    ]

    system "./configure", *args
    system "make", "install"
  end
end
