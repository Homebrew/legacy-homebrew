require 'formula'

class Pgtap < Formula
  url 'http://pgfoundry.org/frs/download.php/2701/pgtap-0.24.tar.bz2'
  homepage 'http://pgtap.org'
  md5 '9d0360c87fca0ddf3ca9da49b9b71947'

  skip_clean :all

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

    system "make install"
    bin.install %w(bbin/pg_prove bbin/pg_tapgen)
  end
end
