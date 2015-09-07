class Libelf < Formula
  desc "ELF object file access library"
  homepage "http://www.mr511.de/software/"
  url "http://www.mr511.de/software/libelf-0.8.14.tar.gz"
  sha256 "8022ccbd568c02e0b36331e533f78eeb3d0d1fa5637adac9b8b816d1ea358ebf"

  bottle do
    cellar :any
    sha256 "5b4f036ec416c1f8d49cf524baf0c3b5b1b6c08a0a11e6991a16a640bd954e1e" => :yosemite
    sha256 "795a8e67f7c32b39dd8a05e1eb31458e41ad0cbb569baf610ee5e532e8246c68" => :mavericks
    sha256 "08f2f5b84072b5d7ec0a2fd2ac0a4c7dd7bdb5fd17fd4015df8882a07d273ec6" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-compat"
    # Use separate steps; there is a race in the Makefile.
    system "make"
    mkdir_p lib
    mkdir_p include+name
    system "make", "install"
  end
end
