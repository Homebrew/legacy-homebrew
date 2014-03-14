require 'formula'

class Cdrtools < Formula
  homepage 'http://cdrecord.berlios.de/private/cdrecord.html'
  url 'ftp://ftp.berlios.de/pub/cdrecord/cdrtools-3.00.tar.gz'
  sha1 '2cd7d1725e0da2267b7a033cc744295d6e2bc6b9'

  depends_on 'smake' => :build

  conflicts_with 'dvdrtools',
    :because => 'both dvdrtools and cdrtools install binaries by the same name'

  patch :p0 do
    url "https://trac.macports.org/export/104091/trunk/dports/sysutils/cdrtools/files/patch-include_schily_sha2.h"
    sha1 "6c2c06b7546face6dd58c3fb39484b9120e3e1ca"
  end

  def install
    system "smake", "INS_BASE=#{prefix}", "INS_RBASE=#{prefix}", "install"
    # cdrtools tries to install some generic smake headers, libraries and
    # manpages, which conflict with the copies installed by smake itself
    (include/"schily").rmtree
    %w[libschily.a libdeflt.a libfind.a].each do |file|
      (lib/file).unlink
    end
    (lib/"profiled").rmtree
    man5.rmtree
  end
end
