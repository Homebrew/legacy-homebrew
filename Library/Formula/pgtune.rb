require 'formula'

class Pgtune < Formula
  homepage 'http://pgfoundry.org/projects/pgtune'
  url 'http://pgfoundry.org/frs/download.php/2449/pgtune-0.9.3.tar.gz'
  sha1 'c638ee3be7bd33f313c280cff9dee2d47bb40e46'

  # 0.9.3 does not have settings for PostgreSQL 9.x, but the trunk does
  head 'https://github.com/gregs1104/pgtune.git'

  def install
    # By default, pgtune searches for settings in the directory
    # where the script is being run from. We replace the default
    # path with pgtune_share.
    pgtune_share = share/'pgtune'
    inreplace 'pgtune' do |s|
      s.sub! /(parser\.add_option\('-S'.*default=).*,/, "\\1\"#{pgtune_share}\","
    end
    bin.install 'pgtune'
    pgtune_share.install Dir['pg_settings*']
  end
end
