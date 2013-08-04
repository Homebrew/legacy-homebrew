require 'formula'

class HgFastExport < Formula
  homepage 'http://packages.debian.org/source/sid/hg-fast-export'
  url 'git://repo.or.cz/fast-export.git', :revision => '3ff69b5392ffd75ee02cd38826d3ca8a9c738231'

  def install
    bin.install 'hg-fast-export.py', 'hg-fast-export.sh',
                'hg-reset.py', 'hg-reset.sh',
                'hg2git.py'
  end
end
