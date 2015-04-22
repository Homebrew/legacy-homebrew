class PilotLink < Formula
  homepage "http://www.pilot-link.org/"
  url "http://downloads.pilot-link.org/pilot-link-0.12.5.tar.gz"
  sha256 "159b84cadf5cdb39e238feaa652e98fc289a5624356a8ddd7f84d6a55eb5c736"

  depends_on "popt"
  depends_on "libpng"

  # Fix compilation issue with modern libpng
  # See http://www.freebsd.org/cgi/query-pr.cgi?pr=145163
  # and http://bugs.debian.org/636758
  patch :p0 do
    url "https://bugs.freebsd.org/bugzilla/attachment.cgi?id=104905"
    sha256 "ef01161ddc0ccf171fe7c71946be7a382750f65e7004b676d9da59065914874e"
  end
  patch :p0 do
    url "https://bugs.freebsd.org/bugzilla/attachment.cgi?id=104906"
    sha256 "6aff9421e152a81eca221c064d7382126d4b6016cbad3a4f9f0e82e7f88d0f07"
  end
  patch :p0 do
    url "https://bugs.freebsd.org/bugzilla/attachment.cgi?id=104907"
    sha256 "4f9e1ed5e1aae06574135f69ebbf9464873248d8c0342db735a3eece18c7def7"
  end
  patch :p0 do
    url "https://bugs.freebsd.org/bugzilla/attachment.cgi?id=104908"
    sha256 "c4cb2cdb8629d9cecefcca58d23bad170e41783574f7bfffe48572e91c1eb893"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--enable-conduits",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/pilot-xfer", "--version"
  end
end
