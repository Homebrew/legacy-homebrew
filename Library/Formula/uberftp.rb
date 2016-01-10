class Uberftp < Formula
  desc "Interactive GridFTP client"
  homepage "http://dims.ncsa.illinois.edu/set/uberftp/"
  url "https://github.com/JasonAlt/UberFTP/archive/Version_2_7.tar.gz"
  sha256 "29a111a86fa70dbbc529a5d3e5a6befc1681e64e32dc019a1a6a98cd43ffb204"

  depends_on "globus-toolkit"

  def install
    # get the flavor
    globus = Formula["globus-toolkit"].opt_prefix

    core = `"#{globus}/sbin/gpt-query" globus_core`
    flavor = case core
    when /gcc64dbg/ then "gcc64dbg"
    when /gcc32dbg/ then "gcc32dbg"
    end

    system "./configure", "--prefix=#{prefix}",
                          "--with-globus-flavor=#{flavor}",
                          "--with-globus=#{globus}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/uberftp", "-v"
  end
end
