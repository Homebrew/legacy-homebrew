class Mdxmini < Formula
  desc "Plays music in X68000 MDX chiptune format"
  homepage "http://clogging.web.fc2.com/psp/"
  url "https://github.com/mistydemeo/mdxmini/archive/v1.0.0.tar.gz"
  sha256 "5a407203f35d873c3cd5977213b0c33a1ce283d6b14483e9d434de79b05ca4e2"

  bottle do
    cellar :any
    revision 1
    sha256 "d20b94107c25833096401be6336544f283e6956758d4238e207e6a4e34fa5fdf" => :el_capitan
    sha256 "55cf6b84d9a0e649e25db7626db954a47bf1061afd20a959972470b6e5cc9fa2" => :yosemite
    sha256 "d08a617e3a8791b9e5dc93426f3d471408550a4a0bab85e33a726ccdcdcb683c" => :mavericks
  end

  option "with-lib-only", "Do not build commandline player"
  deprecated_option "lib-only" => "with-lib-only"

  depends_on "sdl" if build.without? "lib-only"

  resource "test_song" do
    url "http://ftp.modland.com/pub/modules/MDX/Popful%20Mail/pop-00.mdx"
    sha256 "86f21fbbaf93eb60e79fa07c759b906a782afe4e1db5c7e77a1640e6bf63fd14"
  end

  def install
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
