class X264 < Formula
  desc "H.264/AVC encoder"
  homepage "https://www.videolan.org/developers/x264.html"
  # the latest commit on the stable branch
  url "https://git.videolan.org/git/x264.git", :revision => "a0cd7d38acb6c31973228ab207e18344920e0aa3"
  version "r2601"

  devel do
    # the latest commit on the master branch
    url "https://git.videolan.org/git/x264.git", :revision => "75992107adcc8317ba2888e3957a7d56f16b5cd4"
    version "r2638"
  end

  head "https://git.videolan.org/git/x264.git"

  bottle do
    cellar :any
    sha256 "010cb2be57c48fb617749e583ad2fbeb148cc522b47d59b407dfb9f10f1f3a2b" => :el_capitan
    sha256 "e093adfd1af594a592ace82f77bd59748e3040d263e507acd3d8ad2275292e16" => :yosemite
    sha256 "977c077c5d38c1a5842bda75aec11831f4980ae258556b9bd9ba2184deb11faa" => :mavericks
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
