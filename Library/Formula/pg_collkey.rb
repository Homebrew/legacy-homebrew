require 'formula'

class PgCollkey < Formula
  homepage 'http://www.public-software-group.org/pg_collkey'
  url 'http://www.public-software-group.org/pub/projects/pg_collkey/v0.4/pg_collkey-v0.4.tar.gz'
  md5 '5934dda868e4eba38ac891b68f954dc7'

  depends_on 'icu4c'
  depends_on 'postgresql'

  def patches
    "https://github.com/ccutrer/pg_collkey/compare/v0.4...master.diff"
  end

  def install
    system "make install"
  end

  def test
    true
  end
end
