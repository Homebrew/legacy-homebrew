require 'formula'

class Ssss <Formula
  url 'http://point-at-infinity.org/ssss/ssss-0.5.tar.gz'
  homepage 'http://point-at-infinity.org/ssss/'
  md5 '24227252aa195a146d09de1df10357a1'

  depends_on 'gmp'
  depends_on 'xmltoman'

  def install

    inreplace 'Makefile' do |contents|
      # Compile with -DNOMLOCK to avoid warning on every run on OS X.
      contents.gsub! /\-W/, '-W -DNOMLOCK $(CFLAGS) $(LDFLAGS)'
      contents.change_make_var! "CC", ENV.cc
    end

    ENV.append 'CFLAGS', "-I#{HOMEBREW_PREFIX}/include"
    system "make"
    prefix.install %w{ HISTORY LICENSE THANKS }
    man1.install %w{ ssss.1 }
    bin.install %w{ ssss-combine ssss-split }
  end

end

