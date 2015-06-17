class Mdxmini < Formula
  desc "Plays music in X68000 MDX chiptune format"
  homepage "http://clogging.web.fc2.com/psp/"
  url "https://github.com/BouKiCHi/mdxplayer/archive/ae219b67a9d2a82f43ba35323c1d85d33959d319.tar.gz"
  version "20140608"
  sha256 "a3c4f1b60a3771826de9d3615a7485126818811a3b119ee1354e7b1cb84b66b3"

  bottle do
    cellar :any
    revision 1
    sha256 "bb3f0d5bbdf5821be5b0d89c2853dd5eda4c1fffa10cc1d294d4c2b63b2566b1" => :yosemite
    sha256 "68d0cbfa239f1f57fee504253d9fe5ed2dc3ac98ae664d09ab4c5e8073307a01" => :mavericks
    sha256 "6a554417e024538317fc92d7a13f82a31aac23b2a79a76b93ef33dee85329970" => :mountain_lion
  end

  option "with-lib-only", "Do not build commandline player"
  deprecated_option "lib-only" => "with-lib-only"

  depends_on "sdl" if build.without? "lib-only"

  # Include NLG code in libmdxmini
  # Submitted upstream: https://github.com/BouKiCHi/mdxplayer/pull/6
  patch do
    url "https://github.com/mistydemeo/mdxplayer/commit/ca7bad8f5b74a425765b161a213180c0654f914d.diff"
    sha256 "6d49d632324942bd4901ef1c32d0a2a83a5265fa3ea258fdcef2ed329a6cd1f9"
  end

  # Fix undefined reference to externed variable in libmdxmini
  patch do
    url "https://github.com/mistydemeo/mdxplayer/commit/48075d7e9b136087f2d97d6be4fb2653b5ff66e3.diff"
    sha256 "6aee796397c66b41cc0332545ebd0b1ac8ee35b7647949461d0ad9b51ebd1fed"
  end

  resource "test_song" do
    url "ftp://ftp.modland.com/pub/modules/MDX/Popful Mail/pop-00.mdx"
    sha256 "86f21fbbaf93eb60e79fa07c759b906a782afe4e1db5c7e77a1640e6bf63fd14"
  end

  def install
    cd "jni/mdxmini" do
      # Specify Homebrew's cc
      inreplace "mak/general.mak", "gcc", ENV.cc
      if build.with? "lib-only"
        system "make", "-f", "Makefile.lib"
      else
        system "make"
      end

      # Makefile doesn't build a dylib
      system ENV.cc, "-dynamiclib", "-install_name", "#{lib}/libmdxmini.dylib", "-o", "libmdxmini.dylib", "-undefined", "dynamic_lookup", *Dir["obj/*"]

      bin.install "mdxplay" if build.without? "lib-only"
      lib.install "libmdxmini.dylib"
      (include+"libmdxmini").install Dir["src/*.h"]
    end
  end

  test do
    resource("test_song").stage testpath
    (testpath/"mdxtest.c").write <<-EOS.undent
    #include <stdio.h>
    #include "libmdxmini/mdxmini.h"

    int main(int argc, char** argv)
    {
        t_mdxmini mdx;
        char title[100];
        mdx_open(&mdx, argv[1], argv[2]);
        mdx_get_title(&mdx, title);
        printf("%s\\n", title);
    }
    EOS
    system ENV.cc, "mdxtest.c", "-lmdxmini", "-o", "mdxtest"

    result = `#{testpath}/mdxtest #{testpath}/pop-00.mdx #{testpath}`.chomp
    result.force_encoding("ascii-8bit") if result.respond_to? :force_encoding
    # Song title is in Shift-JIS
    expected = "\x82\xDB\x82\xC1\x82\xD5\x82\xE9\x83\x81\x83C\x83\x8B         \x83o\x83b\x83N\x83A\x83b\x83v\x8D\xEC\x90\xAC          (C)Falcom 1992 cv.\x82o\x82h. ass.\x82s\x82`\x82o\x81{"
    expected.force_encoding("ascii-8bit") if result.respond_to? :force_encoding
    assert_equal expected, result
  end
end
