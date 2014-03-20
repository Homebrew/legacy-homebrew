require 'formula'

class Libid3tag < Formula
  homepage 'http://www.underbit.com/products/mad/'
  url 'https://downloads.sourceforge.net/project/mad/libid3tag/0.15.1b/libid3tag-0.15.1b.tar.gz'
  sha1 '4d867e8a8436e73cd7762fe0e85958e35f1e4306'

  bottle do
    cellar :any
    sha1 "fc017adc0de8aaf7605bb8a6cc5c0a2fac2445c9" => :mavericks
    sha1 "323b281abe8edd5e43644ce6804ac3057ad6fa59" => :mountain_lion
    sha1 "e77397115b59362892efc13fed00e1e8ba06097e" => :lion
  end

  # patch for utf-16 (memory leaks), see https://bugs.launchpad.net/mixxx/+bug/403586
  {
    "utf16.patchlibid3tag-0.15.1b-utf16" => "daf621e8123530fdab5193099031074666fc7330",
    "unknown-encoding"                   => "093def535edb3d2f5be6b173eedf0f93a1c0314c",
    "compat"                             => "8c179b10bf49385e4334aab141e4cf270cb02182",
    "file-write"                         => "b7baae1c87f90aac64a4d17725b2eaad521e42af",
  }.each do |name, sha|
    patch do
      url "http://mirror.ovh.net/gentoo-portage/media-libs/libid3tag/files/0.15.1b/libid3tag-0.15.1b-#{name}.patch"
      sha1 sha
    end
  end

  # typedef for 64-bit long + buffer overflow
  {
    "64bit-long"   => "f9778590811a050384b9bf8827345b61999f0da3",
    "fix_overflow" => "ed80bc74bd81caa225952f72a1a28d54300e43e3",
    "tag"          => "b7ef9a41a31a37b8bb6d8e064b0c0ba618d3fa03",
  }.each do |name, sha|
    patch :p0 do
      url "http://mirror.ovh.net/gentoo-portage/media-libs/libid3tag/files/0.15.1b/libid3tag-0.15.1b-#{name}.patch"
      sha1 sha
    end
  end

  # corrects "a cappella" typo
  patch :p2 do
    url "http://mirror.ovh.net/gentoo-portage/media-libs/libid3tag/files/0.15.1b/libid3tag-0.15.1b-a_capella.patch"
    sha1 "f4c4a728e7e36b6396c5b4d5841728b89e6f2fe7"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"

    (lib+'pkgconfig/id3tag.pc').write pc_file
  end

  def pc_file; <<-EOS.undent
    prefix=#{opt_prefix}
    exec_prefix=${prefix}
    libdir=${exec_prefix}/lib
    includedir=${prefix}/include

    Name: id3tag
    Description: ID3 tag reading library
    Version: #{version}
    Requires:
    Conflicts:
    Libs: -L${libdir} -lid3tag -lz
    Cflags: -I${includedir}
    EOS
  end
end
