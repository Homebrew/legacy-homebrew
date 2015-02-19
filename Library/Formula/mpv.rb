class JackOSX < Requirement
  fatal true

  env do
    ENV.append "CFLAGS",  "-I/usr/local/include"
    ENV.append "LDFLAGS", "-L/usr/local/lib -ljack -framework CoreAudio -framework CoreServices -framework AudioUnit"
  end

  def satisfied?
    which("jackd")
  end
end

class Mpv < Formula
  homepage "https://github.com/mpv-player/mpv"
  url "https://github.com/mpv-player/mpv/archive/v0.8.0.tar.gz"
  sha1 "8185c54989a92d7e622850ef869180cf3e239d2f"
  head "https://github.com/mpv-player/mpv.git"

  depends_on "pkg-config" => :build
  depends_on :python

  option "with-libmpv",          "Build shared library."
  option "without-optimization", "Disable compiler optimization."
  option "with-bundle",          "Enable compilation of a Mac OS X Application bundle."
  option "with-jackosx",         "Build with jackosx support."
  option "without-zsh-comp",     "Install without zsh completion"

  depends_on "libass"

  depends_on "ffmpeg"

  depends_on "mpg123"      => :recommended
  depends_on "jpeg"        => :recommended

  depends_on "libcaca"     => :optional
  depends_on "libbs2b"     => :optional
  depends_on "libdvdread"  => :optional
  depends_on "libdvdnav"   => :optional
  depends_on "little-cms2" => :recommended
  depends_on "lua"         => :recommended
  depends_on "libbluray"   => :optional
  depends_on "libaacs"     => :optional
  depends_on :x11          => :optional

  depends_on JackOSX.new if build.with? "jackosx"

  WAF_VERSION = "waf-1.8.4".freeze
  WAF_SHA1    = "42b36fabac41ab6f14ccb4808bd9ec87149a37a9".freeze

  resource "waf" do
    url "http://ftp.waf.io/pub/release/#{WAF_VERSION}"
    sha1 WAF_SHA1
  end

  resource "docutils" do
    url "https://pypi.python.org/packages/source/d/docutils/docutils-0.11.tar.gz"
    sha1 "3894ebcbcbf8aa54ce7c3d2c8f05460544912d67"
  end

  def caveats
    bundle_caveats if build.with? "bundle"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    ENV.prepend_create_path "PATH", libexec/"bin"
    ENV.append "LC_ALL", "en_US.UTF-8"
    resource("docutils").stage { system "python", "setup.py", "install", "--prefix=#{libexec}" }
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])

    args = ["--prefix=#{prefix}"]
    args << "--enable-jack" if build.with? "jackosx"
    args << "--enable-libmpv-shared" << "--disable-client-api-examples" if build.with? "libmpv"
    args << "--disable-optimize" if build.without?("optimization") && build.head?
    args << "--enable-zsh-comp" if build.with? "zsh-comp"

    # For running version.sh correctly
    buildpath.install_symlink cached_download/".git" if build.head?
    buildpath.install resource("waf").files(WAF_VERSION => "waf")
    system "python", "waf", "configure", *args
    system "python", "waf", "install"

    if build.with? "bundle"
      ohai "creating a OS X Application bundle"
      system "python", "TOOLS/osxbundle.py", "build/mpv"
      prefix.install "build/mpv.app"
    end
  end

  private

  def bundle_caveats; <<-EOS.undent
    mpv.app installed to:
      #{prefix}

    To link the application to a normal Mac OS X location:
        brew linkapps
    or:
        ln -s #{prefix}/mpv.app /Applications
    EOS
  end

  test do
    system "#{bin}/mpv", "--ao", "null", "/System/Library/Sounds/Glass.aiff"
  end
end
