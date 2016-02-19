class Googler < Formula
  desc "Google Search and News from the command-line"
  homepage "https://github.com/jarun/googler"
  url "https://github.com/jarun/googler/archive/v2.1.tar.gz"
  sha256 "4f42325b3961efa19c475138507f156891c27db7882ed6f75dfa256aef63016c"

  bottle do
    cellar :any_skip_relocation
    sha256 "e80627b38cfd099190cc1af1046ff1ac68db9440647cad5861e678ddc73306bc" => :el_capitan
    sha256 "73ed00aa66144356692d90992b5686aaee90356e0ec687b59a4260e53e59e027" => :yosemite
    sha256 "c6414018bf2fa23c50e3e7fb76cfa81580f338dad9388fb18b84f586788cbf7c" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard

  def install
    # googler requires Python 2.7+, but its shebang is hard-coded as
    # #!/usr/bin/python, so there might be problems on Snow Leopard. As
    # a work around we replace /usr/bin/python with brewed Python on
    # Snow Leopard. This workaround won't be needed when
    # https://github.com/jarun/googler/issues/23 is resolved.
    inreplace "googler", "#!/usr/bin/python", "#!#{HOMEBREW_PREFIX}/bin/python" if MacOS.version <= :snow_leopard
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match /Usage: googler/, `#{bin}/googler`
  end
end
