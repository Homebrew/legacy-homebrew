require 'formula'

class CppBtree < Formula
  homepage 'https://code.google.com/p/cpp-btree/'
  url 'https://cpp-btree.googlecode.com/files/cpp-btree-1.0.1.tar.gz'
  sha1 '92853bc483cf136dfd7c1c6a24723f459e8bc17e'

  def install
    include.install 'btree_container.h', 'btree_map.h',
                    'btree_set.h', 'btree.h', 'safe_btree_map.h',
                    'safe_btree_set.h', 'safe_btree.h'
  end
end
