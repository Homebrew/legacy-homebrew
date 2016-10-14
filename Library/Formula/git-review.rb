# Packaged on 2012-01-31 by Antoine "hashar" Musso for
# the Wikimedia Foundation.

require 'formula'

class GitReview < Formula
  url 'http://pypi.python.org/packages/source/g/git-review/git-review-1.12.tar.gz'
  homepage 'https://github.com/openstack-ci/git-review#readme'
  md5 '6935383997db544f2c310650eac37e5b'

  # For the adventurous:
  head 'https://github.com/openstack-ci/git-review.git'


  def install
    system "python", "setup.py", "install", "--prefix=#{prefix}"
    man1.install gzip('git-review.1')
    prefix.install %w[
      README.md
      LICENSE
      AUTHORS
      HACKING
    ]
  end

end
