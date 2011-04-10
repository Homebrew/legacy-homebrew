require 'formula'

class DoctorJs < Formula
  head 'https://github.com/mozilla/doctorjs.git', :using => :git
  homepage 'https://github.com/mozilla/doctorjs'

  depends_on 'node'

  def install
    system "make install"
  end
end
