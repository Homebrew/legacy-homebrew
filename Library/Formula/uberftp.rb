class Uberftp < Formula
  desc "Interactive GridFTP client"
  homepage 'http://dims.ncsa.illinois.edu/set/uberftp/'
  url 'https://github.com/JasonAlt/UberFTP/archive/Version_2_8.tar.gz'
  sha256 '8a397d6ef02bb714bb0cbdb259819fc2311f5d36231783cd520d606c97759c2a'

  depends_on "globus-toolkit"

  def install
    globus = Formula["globus-toolkit"].opt_prefix

    inreplace "configure", "globus_location/include/globus/gcc64dbg", "globus_location/libexec/include"
    inreplace "configure", "globus_location/lib64", "globus_location/libexec/lib"

    system "./configure", "--prefix=#{prefix}",
                          "--with-globus=#{globus}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/uberftp", "-v"
  end
end
