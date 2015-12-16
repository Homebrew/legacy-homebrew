class Librsync < Formula
  desc "Library that implements the rsync remote-delta algorithm"
  homepage "http://librsync.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/librsync/librsync/0.9.7/librsync-0.9.7.tar.gz"
  sha256 "6633e4605662763a03bb6388529cbdfd3b11a9ec55b8845351c1bd9a92bc41d6"

  bottle do
    cellar :any
    revision 1
    sha256 "12560a233362faa837f9ade76bc4e0018b02fe872cb7f7b3b45351c24a09ec10" => :el_capitan
    sha256 "89629dde5a47b7da9990f4e2c1804215f1326c302a53312e7c2a3a917aa5d855" => :yosemite
    sha256 "d8afefbdd50533a2198376e3f0cadbb2e128c32bc3ad8d1f39fb338fb3ae3fb3" => :mavericks
    sha256 "629cc851c9096a8c815c3c4e93ee0914d8f66039acfff0ade225a0b02b5dfaa7" => :mountain_lion
  end

  option :universal

  depends_on "popt"

  def install
    ENV.universal_binary if build.universal?

    ENV.append "CFLAGS", "-std=gnu89"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--enable-shared"

    inreplace "libtool" do |s|
      s.gsub! /compiler_flags=$/, "compiler_flags=' #{ENV.cflags}'"
      s.gsub! /linker_flags=$/, "linker_flags=' #{ENV.ldflags}'"
    end

    system "make", "install"
  end
end
