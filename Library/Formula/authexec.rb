require "formula"

class Authexec < Formula
  homepage "https://github.com/tcurdt/authexec"
  url "https://github.com/tcurdt/authexec/archive/1.0.tar.gz"
  sha1 "73d8fb4202ae99057691788442bb192972ef304c"

  head "https://github.com/tcurdt/authexec.git"

  # AuthorizationExecuteWithPrivileges was depreciated in OS X 10.7
  # Installing this on newer systems throws up an ugly, blunt OS X warning.
  # Running anything under it on newer systems also gets a `status: -60031` error
  depends_on MaximumMacOSRequirement => :lion

  def install
    system ENV.cc, "authexec.c", "-framework", "Security", "-o", "authexec"
    bin.install "authexec"
  end
end
