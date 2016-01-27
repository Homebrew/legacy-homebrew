class Schismtracker < Formula
  desc "Portable reimplementation of Impulse Tracker"
  homepage "http://schismtracker.org"
  url "http://schismtracker.org/dl/schismtracker-20120105.tar.bz2"
  sha256 "31cef23e6806027618aef03675a5e4681043a99afa6e9e92d82ad4cec5e6c7db"

  bottle do
    cellar :any
    sha256 "98dc9ae978d7fb1edcfe16565099c1bd1aca7da559d39a11e29efc1df94a8bac" => :el_capitan
    sha256 "1eee656439ae0fc622c441ddb850ead5c5d361326b556e16f9ce00437988a86a" => :yosemite
    sha256 "f892d60e3e74f352d7d9efbbf84b6470e4e751ffafe55c9b6ab9913bd611dba2" => :mavericks
  end

  head do
    url "http://schismtracker.org/hg/", :using => :hg

    depends_on "autoconf" => :build
  end

  depends_on "sdl"

  # CC BY-NC-ND licensed set of five mods by Keith Baylis/Vim! for testing purposes
  # Mods from Mod Soul Brother: http://web.archive.org/web/20120215215707/http://www.mono211.com/modsoulbrother/vim.html
  resource "demo_mods" do
    url "https://files.scene.org/get:us-http/mirrors/modsoulbrother/vim/vim-best-of.zip"
    sha256 "df8fca29ba116b10485ad4908cea518e0f688850b2117b75355ed1f1db31f580"
  end

  def install
    system "autoreconf", "-ivf" if build.head?

    mkdir "build" do
      # Makefile fails to create this directory before dropping files in it
      mkdir "auto"

      system "../configure", "--disable-debug",
                            "--disable-dependency-tracking",
                            "--disable-silent-rules",
                            "--prefix=#{prefix}"
      system "make", "install"
    end
  end

  test do
    testpath.install resource("demo_mods")
    test_wav = "#{testpath}/test.wav"
    system "#{bin}/schismtracker", "-p", "#{testpath}/give-me-an-om.mod",
           "--diskwrite=#{test_wav}"
    assert File.exist? test_wav
    assert_match /RIFF \(little-endian\) data, WAVE audio, Microsoft PCM, 16 bit, stereo 44100 Hz/,
                 shell_output("/usr/bin/file '#{test_wav}'")
  end
end
