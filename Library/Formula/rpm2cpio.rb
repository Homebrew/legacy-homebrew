require 'formula'

class Rpm2cpio < Formula
  homepage 'http://www.freebsd.org/cgi/cvsweb.cgi/ports/archivers/rpm2cpio/'
  url 'http://www.freebsd.org/cgi/cvsweb.cgi/~checkout~/ports/archivers/rpm2cpio/files/rpm2cpio?rev=1.4'
  version '1.4'
  sha1 '7bd6e848eed9444a4dacf9759cc195ca56ab19b2'

  # Uses xz and lzma tools at runtime
  depends_on 'xz'

  def install
    bin.install 'rpm2cpio?rev=1.4' => 'rpm2cpio'
  end
end
