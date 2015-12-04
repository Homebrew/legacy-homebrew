class Libid3tag < Formula
  desc "ID3 tag manipulation library"
  homepage "http://www.underbit.com/products/mad/"
  url "https://downloads.sourceforge.net/project/mad/libid3tag/0.15.1b/libid3tag-0.15.1b.tar.gz"
  sha256 "63da4f6e7997278f8a3fef4c6a372d342f705051d1eeb6a46a86b03610e26151"

  bottle do
    cellar :any
    revision 1
    sha256 "75e446174dd2a9dc17326c998757c4218a89cddb734f3000d0b0506de801732a" => :el_capitan
    sha256 "07ef662e3ab9be0cce16eabb13dbc046fc60c42184ac003285371dc955859697" => :yosemite
    sha256 "d832f73e16b185fed6a66d2f00199a7d76411e438854988262463f4769b40d5b" => :mavericks
    sha256 "35d74caea8ad8110b36e9718175ef9a7f2824cc70c0d470018ad70319ced7b69" => :mountain_lion
  end

  # patch for utf-16 (memory leaks), see https://bugs.launchpad.net/mixxx/+bug/403586
  {
    "utf16.patchlibid3tag-0.15.1b-utf16" => "daf621e8123530fdab5193099031074666fc7330",
    "unknown-encoding"                   => "093def535edb3d2f5be6b173eedf0f93a1c0314c",
    "compat"                             => "8c179b10bf49385e4334aab141e4cf270cb02182",
    "file-write"                         => "b7baae1c87f90aac64a4d17725b2eaad521e42af"
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
    "tag"          => "b7ef9a41a31a37b8bb6d8e064b0c0ba618d3fa03"
  }.each do |name, sha|
    patch :p0 do
      url "http://mirror.ovh.net/gentoo-portage/media-libs/libid3tag/files/0.15.1b/libid3tag-0.15.1b-#{name}.patch"
      sha1 sha
    end
  end

  # corrects "a cappella" typo
  patch :p2 do
    url "http://mirror.ovh.net/gentoo-portage/media-libs/libid3tag/files/0.15.1b/libid3tag-0.15.1b-a_capella.patch"
    sha256 "5e86270ebb179d82acee686700d203e90f42e82beeed455b0163d8611657d395"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make", "install"

    (lib+"pkgconfig/id3tag.pc").write pc_file
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
