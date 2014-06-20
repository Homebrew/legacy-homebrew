require 'formula'

class Pdsh < Formula
  homepage 'https://code.google.com/p/pdsh/'
  url 'https://code.google.com/p/pdsh/', :tag => 'pdsh-2.31', :using => :git
  sha1 '03f1f82761162e5f0d382f4e586aae9fb0ef7ef9'

  head 'https://code.google.com/p/pdsh/', :using => :git

  conflicts_with 'clusterit', :because => 'both install `dshbak`'

  option "without-dshgroups", "Compile without dshgroups which conflicts with genders. The option should be specified to load genders module first instead of dshgroups."

  depends_on 'readline'
  depends_on 'genders' => :optional

  def install
    args = ["--prefix=#{prefix}",
            "--mandir=#{man}",
            "--with-ssh",
            "--without-rsh",
            "--with-nodeupdown",
            "--with-readline",
            "--without-xcpu"]

    args << '--with-genders' if build.with? 'genders'
    args << ((build.without? "dshgroups") ? '--without-dshgroups' : '--with-dshgroups')

    system "./configure", *args
    system "make install"
  end

  test do
    system "#{bin}/pdsh", "-V"
  end
end
