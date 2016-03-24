class Lsyncd < Formula
  desc "Synchronize local directories with remote targets"
  homepage "https://github.com/axkibe/lsyncd"
  url "https://github.com/axkibe/lsyncd/archive/release-2.1.6.tar.gz"
  sha256 "02c241ee71b6abb23a796ac994a414e1229f530c249b838ae72d2ef74ae0f775"

  bottle do
    cellar :any
    sha256 "077da32f3468d592dbb3cd9c5797286702d501bec1c67d4b1420923c5d52741a" => :el_capitan
    sha256 "ff0c1043f7a96094627f2be1ec488430499dd2da95c53ee9a8c26656ba197292" => :yosemite
    sha256 "4e7752758b7bb76ee244056408fe9e9a9033cc3b24914851c221cc9895200561" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "lua"

  xnu_headers = {
    "10.7"     => ["xnu-1699.22.73.tar.gz",  "c9d24560af543e6099b6248bdbcef3581e7ba4af3afd92974719f7c5a8db5bd2"],
    "10.7.1"   => ["xnu-1699.22.81.tar.gz",  "b1422aadf0d3842f3c97e61178adfddb6596e67ba1d877da7f11e2f455fa8dec"],
    "10.7.2"   => ["xnu-1699.24.8.tar.gz",   "4268ce69799db51f1b48e400b6fa6a7041b266a1a5404034398aa51b7084b269"],
    "10.7.3"   => ["xnu-1699.24.23.tar.gz",  "f91a2e8128e220c7ea21ff5c0b61cf76b2afcae83f057d2116837272fd46bead"],
    "10.7.4"   => ["xnu-1699.26.8.tar.gz",   "76f0e6e703218b3b1620b29b7fabb5eb177c990af20711a90085a5a6afc54022"],
    "10.7.5"   => ["xnu-1699.32.7.tar.gz",   "2163816aae990675d8f45cdced4b680bb112fb7a600eb0063af2c2bc2ea15e15"],
    "10.8"     => ["xnu-2050.7.9.tar.gz",    "25c8fc346d1c209f6d20b456dcb256f1e829e844f67b262c090caf088559f4b1"],
    "10.8.1"   => ["xnu-2050.9.2.tar.gz",    "f342179c625413ae3a74fc1a5747fc555c1353cfef6259c595626469744a6405"],
    "10.8.2"   => ["xnu-2050.18.24.tar.gz",  "5d018b33efd9eebb05142958432b9a5058febe04a3b92ba5a16a285490a83445"],
    "10.8.3"   => ["xnu-2050.22.13.tar.gz",  "54011448f0cbb84792146657f4f5f8f64beca52e63bd0eb6028aadedf153a4d6"],
    "10.8.4"   => ["xnu-2050.24.15.tar.gz",  "24e6dc5d98d8f2be450832ea9cfaf2fc85c090422e5b89b24c2a80f0d2957a04"],
    "10.8.5"   => ["xnu-2050.48.11.tar.gz",  "454203188d19a368f850f335a6b4c8fbfc383e929116b2b06e63d8365ccd207e"],
    "10.9"     => ["xnu-2422.1.72.tar.gz",   "fbefe23943d0c4c12b3d7abd3f304224176f269b19ef6ad801314bc69cf773db"],
    "10.9.1"   => ["xnu-2422.1.72.tar.gz",   "fbefe23943d0c4c12b3d7abd3f304224176f269b19ef6ad801314bc69cf773db"],
    "10.9.2"   => ["xnu-2422.90.20.tar.gz",  "7bf3c6bc2f10b99e57b996631a7747b79d1e1684df719196db1e5c98a5585c23"],
    "10.9.3"   => ["xnu-2422.100.13.tar.gz", "0deb3a323804a18e23261b1f770a7b85b6329213cb77f525d5a2663e8961d87a"],
    "10.9.4"   => ["xnu-2422.110.17.tar.gz", "0b973913648d5773367f264002f7832bd01510687fa55a28ef1438c86affa141"],
    "10.9.5"   => ["xnu-2422.115.4.tar.gz",  "1a505922bbf232a616a7398e17eff4477fb0621a6c046ff802a2c7b7bf2b5ceb"],
    "10.10"    => ["xnu-2782.1.97.tar.gz",   "18fd93155c53fa66c48c2c876313311bba55cff260ea10e7b67dd7ed1f4b945c"],
    "10.10.1"  => ["xnu-2782.1.97.tar.gz",   "18fd93155c53fa66c48c2c876313311bba55cff260ea10e7b67dd7ed1f4b945c"],
    "10.10.2"  => ["xnu-2782.10.72.tar.gz",  "0725dfc77ce245e37b57d226445217c17d0a7750db099d3ca69a4ad1c7f39356"],
    "10.10.3"  => ["xnu-2782.20.48.tar.gz",  "d1d7cfdf282b6b651415d5adb7f591f3d7ee0e0ccdd29db664c0ec3f9f827146"],
    "10.10.4"  => ["xnu-2782.30.5.tar.gz",  "16fbd88fb5833fdfb6d8169b7c330d344c12b6a644678a1eb68f27c318b8811d"],
    "10.10.5"  => ["xnu-2782.40.9.tar.gz",  "f9f2524124edebe81bb1ead2f69c3daeed1f37641aef68ac4df5bcffd2ab0898"],
    "10.11"    => ["xnu-3247.1.106.tar.gz",  "660f8f107d284fe797675b0a266c63016876aa5bb4add99d88ffb9cd9001d84f"],
    "10.11.1"  => ["xnu-3247.10.11.tar.gz",  "66ff554039e3b8351fdb2103c4dfb6bf8015c6f9a219f70c057b839cb10b1640"],
    "10.11.2"  => ["xnu-3248.20.55.tar.gz",  "10c3acf0da74d6f4684d6a870b425546fc9c9dcb9c39541556f47cba2440a2ab"],
    "10.11.3"  => ["xnu-3248.20.55.tar.gz",  "10c3acf0da74d6f4684d6a870b425546fc9c9dcb9c39541556f47cba2440a2ab"],
    "10.11.4"  => ["xnu-3248.20.55.tar.gz",  "10c3acf0da74d6f4684d6a870b425546fc9c9dcb9c39541556f47cba2440a2ab"],
  }

  if xnu_headers.key? MACOS_FULL_VERSION
    tarball, checksum = xnu_headers.fetch(MACOS_FULL_VERSION)
    resource "xnu" do
      url "https://opensource.apple.com/tarballs/xnu/#{tarball}"
      sha256 checksum
    end
  end

  def install
    # XNU Headers
    resource("xnu").stage buildpath/"xnu"

    args = std_cmake_args
    args << "-DWITH_INOTIFY=OFF"
    args << "-DWITH_FSEVENTS=ON"
    args << "-DXNU_DIR=#{buildpath/"xnu"}"

    # DESTINATION man
    inreplace "CMakeLists.txt", "DESTINATION man",
                                "DESTINATION #{man}"

    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    system bin/"lsyncd", "--version"
  end
end
