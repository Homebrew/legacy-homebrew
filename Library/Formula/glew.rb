class Glew < Formula
  desc "OpenGL Extension Wrangler Library"
  homepage "http://glew.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/glew/glew/1.13.0/glew-1.13.0.tgz"
  sha256 "aa25dc48ed84b0b64b8d41cdd42c8f40f149c37fa2ffa39cd97f42c78d128bc7"

  bottle do
    cellar :any
    sha256 "177f79a8fe3965c38e99f286c712237c4c33ddcc4cfd216c949393f7e00ae32c" => :el_capitan
    sha256 "4c8befbf2493fa5491e64cf6e6e0db3d8ca876ab31f742af6ad0f7a5548d8e7c" => :yosemite
    sha256 "b5b97f390fd241729c5023941e34378bb3e3c2d64825370fcd5845e3d226ae0d" => :mavericks
    sha256 "ad52c4946186b87fd290833e3b7c68287316f5dc8a2c96f662478a403697bb4f" => :mountain_lion
  end

  option :universal

  def install
    # Makefile directory race condition on lion
    ENV.deparallelize

    if build.universal?
      ENV.universal_binary

      # Do not strip resulting binaries; https://sourceforge.net/p/glew/bugs/259/
      ENV["STRIP"] = ""
    end

    inreplace "glew.pc.in", "Requires: @requireslib@", ""
    system "make", "GLEW_PREFIX=#{prefix}", "GLEW_DEST=#{prefix}", "all"
    system "make", "GLEW_PREFIX=#{prefix}", "GLEW_DEST=#{prefix}", "install.all"
  end

  test do
    assert_match /#{version}/, shell_output("#{bin}/glewinfo")
  end
end
