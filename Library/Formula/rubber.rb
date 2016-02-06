class Rubber < Formula
  desc "Automated building of LaTeX documents"
  homepage "https://launchpad.net/rubber/"
  url "https://launchpad.net/rubber/trunk/1.2/+download/rubber-1.2.tar.gz"
  sha256 "776d859fb75f952cac37bd1b60833840e3a6cdd8d6d01f214b379d3c76618e95"
  version "20150624-1.2"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "45ccf5bf5077477f2352a4264fde561b8fdeb804f8b85185bb278998907cc551" => :el_capitan
    sha256 "b634e0a8fe7fc06182c4931cee9e752c160007dcdf1953a0188f40fe8afe629e" => :yosemite
    sha256 "326ecaa0ef4892714161be2d9bd918d9a8d51bd5c7f9563eb5a77f3853727007" => :mavericks
  end

  head "lp:rubber", :using => :bzr

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--infodir=#{info}"
    # `install` requires but does not make the docs
    system "make"
    system "make", "install"

    # Don't need to peg to a specific Python version
    inreplace Dir["#{bin}/*"], %r{^#!.*\/python.*$}, "#!/usr/bin/env python"

    bin.env_script_all_files(
      libexec/"bin",
      :PYTHONPATH => lib/"python2.7/site-packages"
    )
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rubber --version")
  end
end
