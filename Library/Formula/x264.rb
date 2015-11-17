class X264 < Formula
  desc "H.264/AVC encoder"
  homepage "https://www.videolan.org/developers/x264.html"
  # the latest commit on the stable branch
  url "https://git.videolan.org/git/x264.git", :revision => "0c21480fa2fdee345a3049e2169624dc6fc2acfc"
  version "r2555"

  devel do
    # the latest commit on the master branch
    url "https://git.videolan.org/git/x264.git", :revision => "73ae2d11d472d0eb3b7c218dc1659db32f649b14"
    version "r2579"
  end

  head "https://git.videolan.org/git/x264.git"

  bottle do
    cellar :any
    sha256 "9e54452d398d03432d1a1c6d8c65becf72f0806e6b866e40ea2f93b38cbe3caf" => :el_capitan
    sha256 "59a15f331aa60995fca0fc9d27ad687064a8459aa7b8e10dd068b5b5e7948bed" => :yosemite
    sha256 "0b0fba0bd52fa74352bada52c5dda7d76327c79e81e84a84d636cac21580275b" => :mavericks
    sha256 "141c28c2226424f82968f7ecb92e23a3ce9af6ae5e78beeb31f9e321b88bc8d4" => :mountain_lion
  end

  depends_on "yasm" => :build

  option "with-10-bit", "Build a 10-bit x264 (default: 8-bit)"
  option "with-mp4=", "Select mp4 output: none (default), l-smash or gpac"

  deprecated_option "10-bit" => "with-10-bit"

  case ARGV.value "with-mp4"
  when "l-smash" then depends_on "l-smash"
  when "gpac" then depends_on "gpac"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-shared
      --enable-static
      --enable-strip
    ]
    if Formula["l-smash"].installed?
      args << "--disable-gpac"
    elsif Formula["gpac"].installed?
      args << "--disable-lsmash"
    end
    args << "--bit-depth=10" if build.with? "10-bit"

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <stdint.h>
      #include <x264.h>

      int main()
      {
          x264_picture_t pic;
          x264_picture_init(&pic);
          x264_picture_alloc(&pic, 1, 1, 1);
          x264_picture_clean(&pic);
          return 0;
      }
    EOS
    system ENV.cc, "-lx264", "test.c", "-o", "test"
    system "./test"
  end
end
