require 'formula'

class Ssreflect < Formula
  homepage 'http://www.msr-inria.inria.fr/Projects/math-components'
  url 'http://www.msr-inria.inria.fr/Projects/math-components/ssreflect-1.4-coq8.4.tar.gz'
  version '1.4'
  sha1 'c9e678a362973b202a5d90d2abf6436fa1ab4dcf'

  depends_on 'objective-caml'
  depends_on 'coq'

  def install
    ENV.j1

    # Enable static linking.
    inreplace 'Make' do |s|
      s.gsub! /#\-custom/, '-custom'
      s.gsub! /#SSRCOQ/, 'SSRCOQ'
    end

    args = ["COQBIN=#{HOMEBREW_PREFIX}/bin/",
            "COQLIBINSTALL=lib/coq/user-contrib",
            "COQDOCINSTALL=doc/coq",
            "DSTROOT=#{prefix}/"]
    system "make", *args
    system "make", "install", *args
    bin.install 'bin/ssrcoq.byte', 'bin/ssrcoq'
    (share/'ssreflect').install "pg-ssr.el"
  end

end
