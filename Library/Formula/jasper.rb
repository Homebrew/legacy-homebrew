class Jasper < Formula
  desc "Library for manipulating JPEG-2000 images"
  homepage "https://www.ece.uvic.ca/~frodo/jasper/"
  url "http://download.osgeo.org/gdal/jasper-1.900.1.uuid.tar.gz"
  sha256 "0021684d909de1eb2f7f5a4d608af69000ce37773d51d1fb898e03b8d488087d"
  version "1.900.1"
  revision 1

  bottle do
    cellar :any
    revision 1
    sha256 "c70ac7c5c48f01d60d8ef07f8d951cc6ffc4da507bc2218950fed542a2fd5902" => :el_capitan
    sha256 "7a996d9e2a97fd46aceda93413c3e55a4e46be3afae16f4631743cb6ce2602d6" => :yosemite
    sha256 "f3deabb9253d2a32eeb5f4848613e7f18bd3af5e5e44b0c467059f5477b60e31" => :mavericks
    sha256 "b6c2560da91773d9b39a9b77064edeb0a19bf32ada3ae057b38c28025a900975" => :mountain_lion
  end

  option :universal

  depends_on "jpeg"

  fails_with :llvm do
    build 2326
    cause "Undefined symbols when linking"
  end

  # CVE-2011-4516: heap-based buffer overflow
  # CVE-2011-4517: heap-based buffer overflow
  # CVE-2014-8137: double-free
  # CVE-2014-8138: heap-based buffer overflow
  # CVE-2014-8157: off-by-one
  # CVE-2014-8158: multiple stack-based buffer overflows
  # CVE-2014-9029: multiple off-by-one
  patch do
    url "https://gist.githubusercontent.com/nijikon/9e2e062d2c0114b3d384/raw/91d89f4cec3c071b5d802e07a6be51dbaecd784e/src_libjasper_base_jas_icc_c.patch"
    sha256 "9708871017a8766b512fffd2b7dcb94399b43a74f0c4d18f9b0fe4e517a12721"
  end

  patch do
    url "https://gist.githubusercontent.com/nijikon/9e2e062d2c0114b3d384/raw/e5b6f9304766c4a6dac28e6db2a40f5bfadf3cc1/src_libjasper_include_jasper_jas_malloc_h.patch"
    sha256 "0e8907edffbedc0beeb7f8042f6169090d9aa36ec8dd79ca4f5009853f37e63d"
  end

  patch do
    url "https://gist.githubusercontent.com/nijikon/9e2e062d2c0114b3d384/raw/91d89f4cec3c071b5d802e07a6be51dbaecd784e/src_libjasper_base_jas_malloc_c.patch"
    sha256 "3762e7f829a129d3b14a040d08ded0ad0bfe6bf96bd6b8cc41cd20870d40e505"
  end

  patch do
    url "https://gist.githubusercontent.com/nijikon/9e2e062d2c0114b3d384/raw/91d89f4cec3c071b5d802e07a6be51dbaecd784e/src_libjasper_jp2_jp2_dec_c.patch"
    sha256 "a3a24ca52bcf1102e7b18fc971f2a5619f47fd45559d35ff8da7bd710e21320d"
  end

  patch do
    url "https://gist.githubusercontent.com/nijikon/9e2e062d2c0114b3d384/raw/91d89f4cec3c071b5d802e07a6be51dbaecd784e/src_libjasper_jpc_jpc_cs_c.patch"
    sha256 "92fd8c3e73cbc6a0f9f72c1fb137fa9f92a9bddaaec388d3da940c7b7bc2d3fc"
  end

  patch do
    url "https://gist.githubusercontent.com/nijikon/9e2e062d2c0114b3d384/raw/91d89f4cec3c071b5d802e07a6be51dbaecd784e/src_libjasper_jpc_jpc_dec_c.patch"
    sha256 "7f9b659eb60ca2a587010cc216ea4bd192d64856505e21cf340c4f2b2061b9e4"
  end

  patch do
    url "https://gist.githubusercontent.com/nijikon/9e2e062d2c0114b3d384/raw/91d89f4cec3c071b5d802e07a6be51dbaecd784e/src_libjasper_jpc_jpc_qmfb_c.patch"
    sha256 "4e9c9611c715b2148578edde94785296b763eb221e2095bf78a6d3c8ba1d3549"
  end

  # The following patch fixes a bug (still in upstream as of jasper 1.900.1)
  # where an assertion fails when Jasper is fed certain JPEG-2000 files with
  # an alpha channel. See:
  # http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=469786
  patch do
    url "https://gist.githubusercontent.com/nijikon/5154039c919cbc8d6610/raw/3fd8d1f2242592f0f02edb730700ce9291637476/src_libjasper_jpc_jpc_dec.c.patch"
    sha256 "bc935e10fcb02c7d6c532507b7dbe9c4bf3935b1ceb1b5920239b78a2bf0c43f"
  end

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--enable-shared",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end
end
