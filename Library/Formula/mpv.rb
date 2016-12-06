class Mpv < Formula
  desc "Video player based on MPlayer/mplayer2"
  homepage "https://mpv.io"
  url "https://github.com/mpv-player/mpv/archive/v0.13.0.tar.gz"
  sha256 "1372704fd8f5701ef7d60f347fd15fe536e23ef148279bf4a4415e72896912db"
  head "https://github.com/mpv-player/mpv.git"

  option "with-libmpv",          "Build shared libray."
  option "without-docs",         "Disable building man page."
  option "without-bundle",       "Disable compilation of a Mac OS X Application bundle."
  option "without-zsh-comp",     "Install without zsh completion"

  depends_on "pkg-config" => :build

  depends_on "libass"
  depends_on "ffmpeg"

  depends_on "mpg123"      => :recommended
  depends_on "jpeg"        => :recommended
  depends_on "little-cms2" => :recommended
  depends_on "lua"         => :recommended
  depends_on "youtube-dl"  => :recommended

  depends_on "libcaca"     => :optional
  depends_on "libdvdread"  => :optional
  depends_on "libdvdnav"   => :optional
  depends_on "libbluray"   => :optional
  depends_on "libaacs"     => :optional

  WAF_VERSION = "waf-1.8.12"
  WAF_SHA256  = "01bf2beab2106d1558800c8709bc2c8e496d3da4a2ca343fe091f22fca60c98b"

  resource "waf" do
    url "https://waf.io/#{WAF_VERSION}"
    sha256 WAF_SHA256
  end

  resource "docutils" do
    url "https://pypi.python.org/packages/source/d/docutils/docutils-0.12.tar.gz"
    sha256 "c7db717810ab6965f66c8cf0398a98c9d8df982da39b4cd7f162911eb89596fa"
  end

  def install
    args = ["--prefix=#{prefix}"]
    args << "--enable-libmpv-shared" if build.with? "libmpv"
    args << "--enable-zsh-comp" if build.with? "zsh-comp"

    if build.with? "docs"
      ENV.prepend_create_path "PYTHONPATH", buildpath/"lib/python2.7/site-packages"
      resource("docutils").stage do
        system "python", "setup.py", "install", "--prefix=#{buildpath}"
      end
      ENV["RST2MAN"] = buildpath/"bin/rst2man.py"
    else
      args << "--disable-manpage-build"
    end

    buildpath.install resource("waf").files(WAF_VERSION => "waf")
    system "python", "waf", "configure", *args
    system "python", "waf", "install"

    if build.with? "bundle"
      ohai "creating a OS X Application bundle"
      system "python", "TOOLS/osxbundle.py", "build/mpv"
      prefix.install "build/mpv.app"
    end
  end

  test do
    system "#{bin}/mpv"
  end
end
