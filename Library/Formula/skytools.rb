require 'formula'

class Skytools < Formula
  homepage 'http://pgfoundry.org/projects/skytools/'
  url 'http://pgfoundry.org/frs/download.php/2872/skytools-2.1.12.tar.gz'
  md5 '94f3391d5b3c3ac6c2edcbfbda705573'

  def install
    unless `/usr/bin/which pg_config`.size > 0
      opoo "No pg_config was detected."
      puts <<-EOS.undent
        pg_top requires postgresql in order to compile, but pg_config was not
        found. This install will likely fail.

        You can install this with:
          brew install postgresql
        or by using a package installer from the PostgreSQL project itself.
      EOS
    end

    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
