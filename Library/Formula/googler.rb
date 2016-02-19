class Googler < Formula
  desc "Google Search and News from the command-line"
  homepage "https://github.com/jarun/googler"
  url "https://github.com/jarun/googler/archive/v2.1.tar.gz"
  sha256 "4f42325b3961efa19c475138507f156891c27db7882ed6f75dfa256aef63016c"

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
