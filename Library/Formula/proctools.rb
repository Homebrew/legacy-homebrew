require 'formula'

class Proctools < Formula
  homepage 'http://proctools.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/proctools/proctools/0.4pre1/proctools-0.4pre1.tar.gz'
  version '0.4pre1'
  sha1 '2e60ac272532406e595698b1315ccfb481e76d42'

  depends_on :bsdmake

  {
    "pfind-Makefile"        => "7929b43b3eb63589c49ff37d09ec627659317327",
    "pfind-pfind.c"         => "1a35efd089de6d97739b359560c3682767998768",
    "pgrep-Makefile"        => "ba002ff7ebc323e464f91b8c0c2011744ec5e689",
    "pkill-Makefile"        => "a7fc4835d573963ea0c36e3fb9d5615cd5e1971a",
    "proctools-fmt.c"       => "e87e7e62aaba4f4830dbd732e3f1a84f6689943c",
    "proctools-proctools.c" => "c16a2ffc6a633d65c268c74bd73e1907b8e3ff6a",
    "proctools-proctools.h" => "967bd616cb199787dd851a4fab66a2f950e70d54",
  }.each do |name, sha|
    patch :p0 do
      url "https://trac.macports.org/export/89276/trunk/dports/sysutils/proctools/files/patch-#{name}.diff"
      sha1 sha
    end
  end

  def install
    system "bsdmake", "PREFIX=#{prefix}"

    ["pgrep/pgrep", "pkill/pkill", "pfind/pfind"].each do |prog|
      bin.install prog
      man1.install prog + ".1"
    end
  end
end
