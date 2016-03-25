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
    "utf16.patchlibid3tag-0.15.1b-utf16" => "487d0c531f3653f8e754d720729cf1cec1bce6e897b845fa61adaaf2668d1568",
    "unknown-encoding"                   => "8b695c9c05e3885655b2e798326b804011615bc6c831cd55cdbacc456a6b9494",
    "compat"                             => "88f486c3d263a4dd5bb556232dcfe2fba175b5124bcdd72aa6c30f562fc87d53",
    "file-write"                         => "eff855cabd8a51866a29246a1b257da64f46aab72d4b8e163e2a4c0d15165bf1"
  }.each do |name, sha|
    patch do
      url "http://mirror.ovh.net/gentoo-portage/media-libs/libid3tag/files/0.15.1b/libid3tag-0.15.1b-#{name}.patch"
      sha256 sha
    end
  end

  # typedef for 64-bit long + buffer overflow
  {
    "64bit-long"   => "5f8b3d3419addf90977832b0a6e563acc2c8e243bb826ebb6d0ec573ec122e1b",
    "fix_overflow" => "43ea3e0b324fb25802dae6410564c947ce1982243c781ef54b023f060c3b0ac4",
    "tag"          => "ca7262ddad158ab0be804429d705f8c6a1bb120371dec593323fa4876c1b277f"
  }.each do |name, sha|
    patch :p0 do
      url "http://mirror.ovh.net/gentoo-portage/media-libs/libid3tag/files/0.15.1b/libid3tag-0.15.1b-#{name}.patch"
      sha256 sha
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
