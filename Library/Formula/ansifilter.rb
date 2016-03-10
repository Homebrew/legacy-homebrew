class Ansifilter < Formula
  desc "Strip or convert ANSI codes into HTML, (La)Tex, RTF, or BBCode"
  homepage "http://www.andre-simon.de/doku/ansifilter/ansifilter.html"
  url "http://www.andre-simon.de/zip/ansifilter-1.15.tar.bz2"
  sha256 "65dc20cc1a03d4feba990f830186404c90462d599e5f4b37610d4d822d67aec4"

  bottle do
    cellar :any_skip_relocation
    sha256 "6667aee6a06c4e0a27e26571cd22db260e3e0966bdaf76a55935c6ed844938c8" => :el_capitan
    sha256 "aecd1dae1603aea0897c68e35a571d94c1ce9b8e7dff9060f92c0119402f98b6" => :yosemite
    sha256 "487e3176c213604d6583e5e7771ee2374780a01fa6e2b806b0a67097ebc819f9" => :mavericks
    sha256 "6b277efe50b28030bf71de5370f7d314130680260ab6e9cb72ce49ca60e799fa" => :mountain_lion
  end

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    path = testpath/"ansi.txt"
    path.write "f\x1b[31moo"

    assert_equal "foo", shell_output("#{bin}/ansifilter #{path}").strip
  end
end
