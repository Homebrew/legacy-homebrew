class Aide < Formula
  desc "File and directory integrity checker"
  homepage "http://aide.sourceforge.net"

  stable do
    url "https://downloads.sourceforge.net/project/aide/aide/0.15.1/aide-0.15.1.tar.gz"
    sha256 "303e5c186257df8c86e418193199f4ea2183fc37d3d4a9098a614f61346059ef"
  end

  devel do
    url "https://downloads.sourceforge.net/project/aide/devel/0.16a2/aide-0.16a2.tar.gz"
    sha256 "b52451816bc85409ea09dc612e32823336f78438afd28248c252912ea8b91b87"
  end

  head do
    url "http://git.code.sf.net/p/aide/code.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  depends_on "libgcrypt" => :build

  def install
    system "sh", "./autogen.sh" if build.head?

    system "./configure", "--disable-lfs",
                          "--disable-static",
                          "--with-curl",
                          "--with-zlib",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    system "#{bin}/aide", "--version"
  end
end
