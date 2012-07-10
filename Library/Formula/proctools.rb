require 'formula'

class Proctools < Formula
  homepage 'http://proctools.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/proctools/proctools/0.4pre1/proctools-0.4pre1.tar.gz'
  version '0.4pre1'
  sha1 '2e60ac272532406e595698b1315ccfb481e76d42'

  depends_on :bsdmake

  def patches
    base = "https://trac.macports.org/export/89276/trunk/dports/sysutils/proctools/files"
    { :p0 => ["patch-pfind-Makefile.diff",
              "patch-pfind-pfind.c.diff",
              "patch-pgrep-Makefile.diff",
              "patch-pkill-Makefile.diff",
              "patch-proctools-fmt.c.diff",
              "patch-proctools-proctools.c.diff",
              "patch-proctools-proctools.h.diff",
             ].map { |file_name| "#{base}/#{file_name}" }
    }
  end

  def install
    system "bsdmake"

    ["pgrep/pgrep", "pkill/pkill", "pfind/pfind"].each do |prog|
      bin.install prog
      man1.install prog + ".1"
    end
  end
end
